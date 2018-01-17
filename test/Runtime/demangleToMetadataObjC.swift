// RUN: %target-run-simple-swift
// REQUIRES: executable_test
// REQUIRES: objc_interop

import StdlibUnittest
import Foundation

let DemangleToMetadataTests = TestSuite("DemangleToMetadataObjC")

@objc class C : NSObject { }
@objc enum E: Int { case a }
@objc protocol P1 { }

DemangleToMetadataTests.test("@objc classes") {
  expectEqual(type(of: C()), _typeByMangledName("4main1CC")!)
}

DemangleToMetadataTests.test("@objc enums") {
  expectEqual(type(of: E.a), _typeByMangledName("4main1EO")!)
}

func f1_composition_objc_protocol(_: P1) { }

DemangleToMetadataTests.test("@objc protocols") {
  expectEqual(type(of: f1_composition_objc_protocol),
              _typeByMangledName("yy4main2P1_pXE")!)
}

DemangleToMetadataTests.test("Objective-C classes") {
  expectEqual(type(of: NSObject()), _typeByMangledName("So8NSObjectC")!)
}

func f1_composition_NSCoding(_: NSCoding) { }

DemangleToMetadataTests.test("Objective-C protocols") {
  expectEqual(type(of: f1_composition_NSCoding), _typeByMangledName("yySo8NSCoding_pXE")!)
}

DemangleToMetadataTests.test("Classes that don't exist") {
  expectNil(_typeByMangledName("4main4BoomC"))
}

runAllTests()

