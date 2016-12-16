//===---------IRGenPublic.h - Public interface to IRGen ---------*- C++ -*-===//
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
#ifndef SWIFT_IRGEN_IRGENPUBLIC_H
#define SWIFT_IRGEN_IRGENPUBLIC_H

namespace llvm {
  class LLVMContext;
}

namespace swift {
class SILModule;

namespace IRGen {
  class IRGenerator;
  class IRGenModule;

/// Create an IRGen module.
std::pair<std::unique_ptr<IRGenerator>, std::unique_ptr<IRGenModule>>
createIRGenModule(SILModule *SILMod, llvm::LLVMContext &LLVMContext);

} // end namespace IRGen
} // end namespace swift

#endif
