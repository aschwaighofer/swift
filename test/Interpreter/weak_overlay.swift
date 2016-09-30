// RUN: rm -rf %t && mkdir -p %t
// Build the framework.
// RUN: cp -R %S/Inputs/FakeUnavailableObjCFramework.framework %t
// RUN: %target-clang -dynamiclib %S/Inputs/FakeUnavailableObjCFramework.m -fmodules -F %t -framework Foundation -o %t/FakeUnavailableObjCFramework.framework/FakeUnavailableObjCFramework
// Build the overlay.
// RUN: %target-build-swift -emit-library -Xlinker -application_extension -module-link-name swiftFakeUnavailable -autolink-force-load -parse-as-library -force-single-frontend-invocation -module-name FakeUnavailable -emit-module -emit-module-path %t/FakeUnavailable.swiftmodule -o %t/libswiftFakeUnavailable.dylib -F %t %S/Inputs/OverlayFakeUnavailableObjCFramework/FakeUnavailable.swift -Xlinker -weak_framework -Xlinker FakeUnavailableObjCFramework 
// Build an executable with the overlay.
// RUN: %target-build-swift -I %t -F %t %s -o %t/use_weak_overlay -L %t
// Remove the framework.
// RUN: mv %t/FakeUnavailableObjCFramework.framework %t/FakeUnavailableObjCFramework-MovedAside.framework
// Run the executable without the framework present.
// RUN: %target-run %t/use_weak_overlay | %FileCheck %s

// REQUIRES: objc_interop
// REQUIRES: executable_test

import FakeUnavailable
import Foundation

// CHECK: don't crash
print("dont crash")

if #available(OSX 1066.0, iOS 1066.0, watchOS 1066.0, tvOS 1066.0, *) {
 var global = UnavailableObjCClass.foo
}
