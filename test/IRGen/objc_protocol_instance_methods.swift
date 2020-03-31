// RUN: %target-swift-frontend(mock-sdk: %clang-importer-sdk) -emit-ir %s | %FileCheck %s

// REQUIRES: OS=macosx


// Make sure we don't emit duplicate method descriptors

// CHECK: [[CONFORMSTOPROTOCOL:@.*]] = private unnamed_addr constant [20 x i8] c"conformsToProtocol:\00"

// CHECK-NOT: @"_OBJC_$_PROTOCOL_INSTANCE_METHODS_NSObject"{{.*}}[[CONFORMSTOPROTOCOL]]{{.*}}[[CONFORMSTOPROTOCOL]]
// CHECK-NOT: _PROTOCOL_INSTANCE_METHODS_NSObject{{.*}}"\01L_selector_data(conformsToProtocol:)"{{.*}}"\01L_selector_data(conformsToProtocol:)"

// Make sure that extended method types are in sync with entries in method list.
// CHECK: @"_OBJC_$_PROTOCOL_INSTANCE_METHODS_NSObject" = internal global { i32, i32, [5
// CHECK: @"_OBJC_$_PROTOCOL_METHOD_TYPES_NSObject" = internal global [5
import Foundation

@objc protocol P: NSObjectProtocol {}
class C: NSObject, P {}
