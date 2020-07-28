// RUN: %empty-directory(%t)
// RUN: %target-swift-frontend -emit-module-path %t/pre_specialized_module.swiftmodule %S/Inputs/pre_specialized_module.swift
// RUN: %target-swift-frontend -I %t -O -emit-sil %s | %FileCheck %s --check-prefix=OPT
// RUN: %target-swift-frontend -I %t -Onone -emit-sil %s | %FileCheck %s --check-prefix=NONE


// RUN: %empty-directory(%t)
// RUN: %target-swift-frontend -O -emit-module-path %t/pre_specialized_module.swiftmodule %S/Inputs/pre_specialized_module.swift
// RUN: %target-swift-frontend -I %t -O -emit-sil %s | %FileCheck %s --check-prefix=OPT

// RUN: %empty-directory(%t)
// RUN: %target-swift-frontend -O -enable-library-evolution -emit-module-path %t/pre_specialized_module.swiftmodule %S/Inputs/pre_specialized_module.swift
// RUN: %target-swift-frontend -I %t -O -emit-sil %s | %FileCheck %s --check-prefix=OPT

// RUN: %empty-directory(%t)
// RUN: %target-swift-frontend -O -swift-version 5 -enable-library-evolution -emit-module -o /dev/null -emit-module-interface-path %t/pre_specialized_module.swiftinterface %S/Inputs/pre_specialized_module.swift
// RUN: %target-swift-frontend -I %t -O -emit-sil %s | %FileCheck %s --check-prefix=OPT

import pre_specialized_module

// Make sure we generate the public pre-specialized entry points.

// OPT: sil @$s14pre_specialize10testPublic1tyx_tlFSf_Ts5 : $@convention(thin) (Float) -> () {
// OPT: sil @$s14pre_specialize10testPublic1tyx_tlFSi_Ts5 : $@convention(thin) (Int) -> () {

// NONE: sil @$s14pre_specialize10testPublic1tyx_tlFSf_Ts5 : $@convention(thin) (Float) -> () {
// NONE: sil @$s14pre_specialize10testPublic1tyx_tlFSi_Ts5 : $@convention(thin) (Int) -> () {

@_specialize(exported: true, where T == Int)
@_specialize(exported: true, where T == Float)
public func testPublic<T>(t: T) {
  print(t)
}

// OPT: sil @$s14pre_specialize18testEmitIntoClient1tyx_tlFSf_Ts5 : $@convention(thin) (Float) -> () {
// OPT: sil @$s14pre_specialize18testEmitIntoClient1tyx_tlFSi_Ts5 : $@convention(thin) (Int) -> () {

// NONE: sil @$s14pre_specialize18testEmitIntoClient1tyx_tlFSf_Ts5 : $@convention(thin) (Float) -> () {
// NONE: sil @$s14pre_specialize18testEmitIntoClient1tyx_tlFSi_Ts5 : $@convention(thin) (Int) -> () {

@_specialize(exported: true, where T == Int)
@_specialize(exported: true, where T == Float)
@_alwaysEmitIntoClient
internal func testEmitIntoClient<T>(t: T) {
  print(t)
}

// OPT: sil @$s14pre_specialize28usePrespecializedEntryPointsyyF : $@convention(thin) () -> () {
// OPT:   [[F1:%.*]] = function_ref @$s22pre_specialized_module20publicPrespecializedyyxlFSi_Ts5 : $@convention(thin) (Int) -> ()
// OPT:   apply [[F1]]
// OPT:   [[F2:%.*]] = function_ref @$s22pre_specialized_module20publicPrespecializedyyxlFSd_Ts5 : $@convention(thin) (Double) -> ()
// OPT:   apply [[F2]]
// OPT:   [[F3:%.*]] = function_ref @$s22pre_specialized_module36internalEmitIntoClientPrespecializedyyxlFSi_Ts5 : $@convention(thin) (Int) -> ()
// OPT:   %11 = apply [[F3]]
// OPT:   [[F4:%.*]] = function_ref @$s22pre_specialized_module36internalEmitIntoClientPrespecializedyyxlFSd_Ts5 : $@convention(thin) (Double) -> ()
// OPT:   apply [[F4]]
// OPT: } // end sil function '$s14pre_specialize28usePrespecializedEntryPointsyyF'

public func usePrespecializedEntryPoints() {
  publicPrespecialized(1)
  publicPrespecialized(1.0)
  useInternalEmitIntoClientPrespecialized(2)
  useInternalEmitIntoClientPrespecialized(2.0)
}
