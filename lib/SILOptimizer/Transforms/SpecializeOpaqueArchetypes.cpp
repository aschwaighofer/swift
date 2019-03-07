#define DEBUG_TYPE "opaque-archetype-specializer"

#include "swift/SIL/SILFunction.h"
#include "swift/SIL/TypeSubstCloner.h"
#include "swift/SIL/SILInstruction.h"
#include "swift/SILOptimizer/PassManager/Transforms.h"


using namespace swift;

namespace {
class OpaqueSpecializerCloner
    : public TypeSubstCloner<OpaqueSpecializerCloner,
                      SILOptFunctionBuilder /*unused*/> {

  using SuperTy =
      TypeSubstCloner<OpaqueSpecializerCloner, SILOptFunctionBuilder>;

  SILBasicBlock *entryBlock;
  SILBasicBlock *cloneFromBlock;

public:
  friend class SILCloner<OpaqueSpecializerCloner>;
  OpaqueSpecializerCloner(SubstitutionMap opaqueArchetypeSubs, SILFunction &fun)
      : SuperTy(fun, fun, opaqueArchetypeSubs) {
    entryBlock = fun.getEntryBlock();
    cloneFromBlock = entryBlock->split(entryBlock->begin());
  }

  void clone();

protected:
  void insertOpaqueToConcreteAddressCasts(SILInstruction *orig,
                                          SILInstruction *cloned);

  void postProcess(SILInstruction *orig, SILInstruction *cloned) {
    SILClonerWithScopes<OpaqueSpecializerCloner>::postProcess(orig, cloned);
    insertOpaqueToConcreteAddressCasts(orig, cloned);
  }

  void visitTerminator(SILBasicBlock *BB) { visit(BB->getTerminator()); }

  SILType remapType(SILType Ty) {
    SILType &Sty = TypeCache[Ty];
    if (!Sty) {
      // Apply the opaque types substitution.
      ReplaceOpaqueTypesWithUnderlyingTypes replacer;
      Sty = Ty.subst(Original.getModule(), SubsMap)
                .subst(Original.getModule(), replacer, replacer,
                       CanGenericSignature(), true);
    }
    return Sty;
  }

  CanType remapASTType(CanType ty) {
    // Apply the opaque types substitution.
    ReplaceOpaqueTypesWithUnderlyingTypes replacer;
    return SuperTy::remapASTType(ty)
        .subst(replacer, replacer,
               SubstFlags::SubstituteOpaqueArchetypes |
                   SubstFlags::AllowLoweredTypes)
        ->getCanonicalType();
  }

  ProtocolConformanceRef remapConformance(Type type,
                                          ProtocolConformanceRef conf) {
    // Apply the opaque types substitution.
    ReplaceOpaqueTypesWithUnderlyingTypes replacer;
    return SuperTy::remapConformance(type, conf)
        .subst(type, replacer, replacer,
               SubstFlags::SubstituteOpaqueArchetypes |
                   SubstFlags::AllowLoweredTypes);
  }

  SubstitutionMap remapSubstitutionMap(SubstitutionMap Subs) {
    // Apply the opaque types substitution.
    ReplaceOpaqueTypesWithUnderlyingTypes replacer;
    return SuperTy::remapSubstitutionMap(Subs).subst(
        replacer, replacer,
        SubstFlags::SubstituteOpaqueArchetypes | SubstFlags::AllowLoweredTypes);
  }
};
} // namespace

void OpaqueSpecializerCloner::clone() {
  for (auto arg: entryBlock->getArguments())
    recordFoldedValue(arg, arg);
  cloneReachableBlocks(cloneFromBlock, {}, entryBlock,
                       true /*havePrepopulatedFunctionArgs*/);
  getBuilder().setInsertionPoint(entryBlock);
  getBuilder().createBranch(RegularLocation::getAutoGeneratedLocation(),
                            getOpBasicBlock(cloneFromBlock));
}

/// Update address uses of the opaque type archetype with the concrete type.
/// This is neccessary for apply instructions.
void OpaqueSpecializerCloner::insertOpaqueToConcreteAddressCasts(
    SILInstruction *orig, SILInstruction *cloned) {

  // Replace apply operands.
  auto apply = ApplySite::isa(cloned);
  if (!apply)
    return;

  SavedInsertionPointRAII restore(getBuilder());
  getBuilder().setInsertionPoint(apply.getInstruction());
  auto substConv = apply.getSubstCalleeConv();
  unsigned idx = 0;
  for (auto &opd : apply.getArgumentOperands()) {
    auto argConv = apply.getArgumentConvention(opd);
    auto argIdx = apply.getCalleeArgIndex(opd);
    auto argType = substConv.getSILArgumentType(argIdx);
    if (argConv.isIndirectConvention() &&
        argType.getASTType()->hasOpaqueArchetype() &&
        !opd.get()->getType().getASTType()->hasOpaqueArchetype()) {
      auto cast = getBuilder().createUncheckedAddrCast(apply.getLoc(),
                                                       opd.get(), argType);
      opd.set(cast);
    }
    ++idx;
  }
}

namespace {
class OpaqueArchetypeSpecializer : public SILFunctionTransform {
  void run() override {

    // Look for opaque type archetypes.
    bool foundOpaqueArchetype = false;
    for (auto &BB : *getFunction()) {
      for (auto &inst : BB) {
        auto *allocStack = dyn_cast<AllocStackInst>(&inst);
        if (!allocStack ||
            !allocStack->getElementType().is<OpaqueTypeArchetypeType>())
          continue;
        foundOpaqueArchetype = true;
        break;
      }
    }

    if (foundOpaqueArchetype) {
      SubstitutionMap subsMap = getFunction()->getForwardingSubstitutionMap();
      OpaqueSpecializerCloner s(subsMap, *getFunction());
      s.clone();
    }

    if (foundOpaqueArchetype)
      invalidateAnalysis(SILAnalysis::InvalidationKind::FunctionBody);
  }
};
} // end anonymous namespace

SILTransform *swift::createOpaqueArchetypeSpecializer() {
  return new OpaqueArchetypeSpecializer();
}
