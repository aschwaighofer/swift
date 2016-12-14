//===--- AllocStackHoisting.cpp - Hoist alloc_stack instructions ----------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "alloc-stack-hoisting"

#include "swift/SILOptimizer/Analysis/Analysis.h"
#include "swift/SILOptimizer/PassManager/Passes.h"
#include "swift/SILOptimizer/PassManager/Transforms.h"
#include "swift/SIL/SILBuilder.h"
#include "swift/SIL/SILInstruction.h"

#include "llvm/Support/Debug.h"

using namespace swift;

/// Hoist generic alloc_stack instructions to the entry basic block.
///
/// This helps avoid llvm.stacksave/stackrestore intrinsic calls during code
/// generation. IRGen will only dynamic alloca instructions if the alloc_stack
/// is in the entry block but will emit a dynamic alloca and
/// llvm.stacksave/stackrestore for all other basic blocks.

/// An alloc_stack instructions is hoistable if it is of generic type and the
/// type parameter is not dependent on an opened type.
static bool isHoistable(AllocStackInst *Inst) {
  auto Type = Inst->getType();
  // We don't need to hoist types that have reference semantics no dynamic
  // alloca will be generated as they are fixed size.
  // Note that no harm is done in hoisting fixed size types (such as a struct
  // that has a generic reference type) because we would allocate the storage
  // for in the entry block anyway (the fixed sized llvm alloca is in they entry
  // block).
  if (!Type.hasArchetype() || Type.hasReferenceSemantics())
    return false;
  // Don't hoist generics with opened archetypes. We would have to hoist the
  // open archetype instruction which might not be possible.
  if (!Inst->getTypeDependentOperands().empty())
    return false;
  return true;
}

/// Collect generic alloc_stack instructions in the function that we can hoist.
/// We can hoist generic alloc_stack instructions if they are not dependent on a
/// another instruction that we would have to hoist.
/// A generic alloc_stack could reference an opened archetype that was not
/// opened in the entry block.
static void collectHoistableAllocStackInstructions(
    SILFunction *F, SmallVectorImpl<AllocStackInst *> &AllocStackToHoist,
    SmallVectorImpl<SILInstruction *> &DeallocPoints) {
  auto *EntryBB = F->entryBB();
  for (auto &BB : *F) {
    if (EntryBB == &BB) // Ignore the entry block.
      continue;
    for (auto &Inst : BB) {
      // Terminators that are function exits are our dealloc_stack
      // insertion points.
      if (auto *Term = dyn_cast<TermInst>(&Inst)) {
        if (Term->isFunctionExiting())
          DeallocPoints.push_back(Term);
        continue;
      }

      auto *ASI = dyn_cast<AllocStackInst>(&Inst);
      if (!ASI) {
        continue;
      }
      if (isHoistable(ASI)) {
        DEBUG(llvm::dbgs() << "Hoisting     " << Inst);
        AllocStackToHoist.push_back(ASI);
      } else {
        DEBUG(llvm::dbgs() << "Not hoisting " << Inst);
      }
    }
  }
}
/// Hoist the alloc_stack instructions to the entry block and sink the
/// dealloc_stack instructions to the function exists.
static void hoistAllocStackInstructions(
    SILFunction *F, SmallVectorImpl<AllocStackInst *> &AllocStackToHoist,
    SmallVectorImpl<SILInstruction *> &FunctionExits) {
  auto *EntryBB = F->entryBB();
  auto *InsertPt = cast<SILInstruction>(EntryBB->begin());
  // Hoist alloc_stacks to the entry block and delete dealloc_stacks.
  for (auto *AllocStack : AllocStackToHoist) {
    AllocStack->moveBefore(InsertPt);
    SmallVector<DeallocStackInst *, 16> DeallocStacksToDelete;
    for (auto *U : AllocStack->getUses()) {
      if (auto *DeallocStack = dyn_cast<DeallocStackInst>(U->getUser()))
        DeallocStacksToDelete.push_back(DeallocStack);
    }
    for (auto *D : DeallocStacksToDelete)
      D->eraseFromParent();
  }
  // Insert dealloc_stack in the exit blocks.
  for (auto *Exit : FunctionExits) {
    SILBuilder Builder(Exit);
    for (auto *AllocStack : reverse(AllocStackToHoist)) {
      Builder.createDeallocStack(AllocStack->getLoc(), AllocStack);
    }
  }
}

/// Try to hoist generic alloc_stack instructions to the entry block.
/// Returns true if the function was changed.
static bool hoistAllocStackInstructions(SILFunction *F) {
  // Collect hoistable generic alloc_stack instructions.
  SmallVector<AllocStackInst *, 16> AllocStackInstToHoist;
  SmallVector<SILInstruction *, 8> DeallocPoints;
  collectHoistableAllocStackInstructions(F, AllocStackInstToHoist,
                                         DeallocPoints);

  // Nothing to hoist?
  if (AllocStackInstToHoist.empty())
    return false;

  hoistAllocStackInstructions(F, AllocStackInstToHoist, DeallocPoints);
  return true;
}

namespace {
class AllocStackHoisting : public SILFunctionTransform {
  void run() override {
    auto *F = getFunction();
    bool Changed = hoistAllocStackInstructions(F);
    if (Changed) {
      PM->invalidateAnalysis(F, SILAnalysis::InvalidationKind::Instructions);
    }
  }
  StringRef getName() override { return "alloc_stack Hoisting"; }
};
} // end anonymous namespace

SILTransform *swift::createAllocStackHoisting() {
  return new AllocStackHoisting();
}
