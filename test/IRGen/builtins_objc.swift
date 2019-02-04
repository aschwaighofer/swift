// RUN: %target-swift-frontend -parse-stdlib -primary-file %s -emit-ir | %FileCheck %s

// REQUIRES: executable_test
// REQUIRES: objc_interop

import Swift
import Foundation
import CoreGraphics

// CHECK: [[INT32:@[0-9]+]] = {{.*}} c"i\00"
// CHECK: [[OBJECT:@[0-9]+]] = {{.*}} c"@\00"

@objc enum ObjCEnum: Int32 { case X }
@objc class ObjCClass: NSObject {}
class NonObjCClass {}

struct AStruct {
  var x: String
}
struct Tuple {
  var x: (Int, Float)
}

enum AnEnum {
  case a
  case b
}

@_silgen_name("use")
func use(_: Builtin.RawPointer)

func getObjCTypeEncoding<T>(_: T) {
  // CHECK: call swiftcc void @use({{.* i8]\*}} [[INT32]],
  use(Builtin.getObjCTypeEncoding(Int32.self))
  // CHECK: call swiftcc void @use({{.* i8]\*}} [[INT32]]
  use(Builtin.getObjCTypeEncoding(ObjCEnum.self))
  // CHECK: call swiftcc void @use({{.* i8]\*}} [[CGRECT:@[0-9]+]],
  use(Builtin.getObjCTypeEncoding(CGRect.self))
  // CHECK: call swiftcc void @use({{.* i8]\*}} [[NSRANGE:@[0-9]+]],
  use(Builtin.getObjCTypeEncoding(NSRange.self))
  // CHECK: call swiftcc void @use({{.* i8]\*}} [[OBJECT]]
  use(Builtin.getObjCTypeEncoding(AnyObject.self))
  // CHECK: call swiftcc void @use({{.* i8]\*}} [[OBJECT]]
  use(Builtin.getObjCTypeEncoding(NSObject.self))
  // CHECK: call swiftcc void @use({{.* i8]\*}} [[OBJECT]]
  use(Builtin.getObjCTypeEncoding(ObjCClass.self))
  // CHECK: call swiftcc void @use({{.* i8]\*}} [[OBJECT]]
  use(Builtin.getObjCTypeEncoding(NonObjCClass.self))
  // CHECK: call swiftcc void @use(i8* null
  use(Builtin.getObjCTypeEncoding(String.self))
  // CHECK: call swiftcc void @use(i8* null
  use(Builtin.getObjCTypeEncoding(Array<Int>.self))
  // CHECK: call swiftcc void @use(i8* null
  use(Builtin.getObjCTypeEncoding(AStruct.self))
  // CHECK: call swiftcc void @use(i8* null
  use(Builtin.getObjCTypeEncoding(AnEnum.self))
  // CHECK: call swiftcc void @use(i8* null
  use(Builtin.getObjCTypeEncoding(Tuple.self))
}

