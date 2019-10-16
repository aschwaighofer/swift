//===--- SerializeSILPass.cpp ---------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "serialize-sil"
#include "swift/Strings.h"
#include "swift/SIL/SILCloner.h"
#include "swift/SIL/SILFunction.h"
#include "swift/SILOptimizer/PassManager/Passes.h"
#include "swift/SILOptimizer/PassManager/Transforms.h"
#include "swift/SILOptimizer/Utils/BasicBlockOptUtils.h"

using namespace swift;

namespace {
/// In place map opaque archetypes to their underlying type in a function.
/// This needs to happen when a function changes from serializable to not
/// serializable.
class MapOpaqueArchetypes : public SILCloner<MapOpaqueArchetypes> {
  using SuperTy = SILCloner<MapOpaqueArchetypes>;

  SILBasicBlock *origEntryBlock;
  SILBasicBlock *clonedEntryBlock;
public:
  friend class SILCloner<MapOpaqueArchetypes>;
  friend class SILCloner<MapOpaqueArchetypes>;
  friend class SILInstructionVisitor<MapOpaqueArchetypes>;

  MapOpaqueArchetypes(SILFunction &fun) : SuperTy(fun) {
    origEntryBlock = fun.getEntryBlock();
    clonedEntryBlock = fun.createBasicBlock();
  }

  SILType remapType(SILType Ty) {
    if (!Ty.getASTType()->hasOpaqueArchetype() ||
        !getBuilder()
             .getTypeExpansionContext()
             .shouldLookThroughOpaqueTypeArchetypes())
      return Ty;

    return getBuilder().getTypeLowering(Ty).getLoweredType().getCategoryType(
        Ty.getCategory());
  }

  CanType remapASTType(CanType ty) {
    if (!ty->hasOpaqueArchetype() ||
        !getBuilder()
             .getTypeExpansionContext()
             .shouldLookThroughOpaqueTypeArchetypes())
      return ty;
    // Remap types containing opaque result types in the current context.
    return getBuilder()
        .getTypeLowering(SILType::getPrimitiveObjectType(ty))
        .getLoweredType()
        .getASTType();
  }

  ProtocolConformanceRef remapConformance(Type ty,
                                          ProtocolConformanceRef conf) {
    auto context = getBuilder().getTypeExpansionContext();
    auto conformance = conf;
    if (ty->hasOpaqueArchetype() &&
        context.shouldLookThroughOpaqueTypeArchetypes()) {
      conformance =
          substOpaqueTypesWithUnderlyingTypes(conformance, ty, context);
    }
    return conformance;
  }

  void replace();
};
} // namespace

void MapOpaqueArchetypes::replace() {
  // Map the function arguments.
  SmallVector<SILValue, 4> entryArgs;
  entryArgs.reserve(origEntryBlock->getArguments().size());
  for (auto &origArg : origEntryBlock->getArguments()) {
    SILType mappedType = remapType(origArg->getType());
    auto *NewArg = clonedEntryBlock->createFunctionArgument(
        mappedType, origArg->getDecl(), true);
    entryArgs.push_back(NewArg);
  }

  getBuilder().setInsertionPoint(clonedEntryBlock);
  auto &fn = getBuilder().getFunction();
  cloneFunctionBody(&fn, clonedEntryBlock, entryArgs,
                    true /*replaceOriginalFunctionInPlace*/);
  // Insert the new entry block at the beginning.
  fn.getBlocks().splice(fn.getBlocks().begin(), fn.getBlocks(),
                        clonedEntryBlock);
  removeUnreachableBlocks(fn);
}

void updateOpaqueArchetypes(SILFunction &F) {
  // TODO: only map if there are opaque archetypes.
  MapOpaqueArchetypes(F).replace();
}

/// A utility pass to serialize a SILModule at any place inside the optimization
/// pipeline.
class SerializeSILPass : public SILModuleTransform {
  /// Removes [serialized] from all functions. This allows for more
  /// optimizations and for a better dead function elimination.
  void removeSerializedFlagFromAllFunctions(SILModule &M) {
    for (auto &F : M) {
      bool wasSerialized = F.isSerialized() != IsNotSerialized;
      F.setSerialized(IsNotSerialized);

      // We are removing [serialized] from the function. This will change how
      // opaque archetypes are lowered in SIL - they might lower to their
      // underlying type. Update the function's opaque archetypes.
      if (wasSerialized && F.isDefinition()) {
        updateOpaqueArchetypes(F);
        invalidateAnalysis(&F, SILAnalysis::InvalidationKind::Everything);
      }
    }

    for (auto &WT : M.getWitnessTables()) {
      WT.setSerialized(IsNotSerialized);
    }

    for (auto &VT : M.getVTables()) {
      VT.setSerialized(IsNotSerialized);
    }
  }

public:
  SerializeSILPass() {}
  void run() override {
    auto &M = *getModule();
    // Nothing to do if the module was serialized already.
    if (M.isSerialized())
      return;

    // Mark all reachable functions as "anchors" so that they are not
    // removed later by the dead function elimination pass. This
    // is required, because clients may reference any of the
    // serialized functions or anything referenced from them. Therefore,
    // to avoid linker errors, the object file of the current module should
    // contain all the symbols which were alive at the time of serialization.
    LLVM_DEBUG(llvm::dbgs() << "Serializing SILModule in SerializeSILPass\n");
    M.serialize();

    // If we are not optimizing, do not strip the [serialized] flag. We *could*
    // do this since after serializing [serialized] is irrelevent. But this
    // would incur an unnecessary compile time cost since if we are not
    // optimizing we are not going to perform any sort of DFE.
    if (!getOptions().shouldOptimize())
      return;
    removeSerializedFlagFromAllFunctions(M);
  }
};

SILTransform *swift::createSerializeSILPass() {
  return new SerializeSILPass();
}
