// RUN: %empty-directory(%t)
// RUN: split-file %s %t

// RUN: %target-swift-frontend -wmo -module-name A -emit-irgen -o %t/A1.ll %t/A.swift -enable-experimental-feature Embedded -enable-experimental-feature EmbeddedExistentials -parse-as-library
// RUN: %FileCheck --check-prefix=A1 %s < %t/A1.ll

// RUN: %target-swift-frontend -wmo -module-name A -num-threads 1 -emit-ir -o %t/A2.ll -o %t/B2.ll %t/A.swift %t/B.swift -enable-experimental-feature Embedded -enable-experimental-feature EmbeddedExistentials -parse-as-library
// RUN: %FileCheck --check-prefix=A2 %s < %t/A2.ll
// RUN: %FileCheck --check-prefix=B2 %s < %t/B2.ll

// RUN: %target-swift-frontend  -emit-module -emit-module-path %t/A.swiftmodule -wmo -module-name A -emit-ir -o %t/A3.ll  %t/A.swift %t/B.swift -enable-experimental-feature Embedded -enable-experimental-feature EmbeddedExistentials -parse-as-library
// RUN: %FileCheck --check-prefix=A3 %s < %t/A3.ll

// RUN: %target-swift-frontend -wmo -I %t -module-name C -emit-irgen -o %t/C4.ll  %t/C.swift -enable-experimental-feature Embedded -enable-experimental-feature EmbeddedExistentials -parse-as-library
// RUN: %FileCheck --check-prefix=C4 %s < %t/C4.ll

// REQUIRES: swift_in_compiler
// REQUIRES: optimized_stdlib
// REQUIRES: swift_feature_Embedded
// REQUIRES: swift_feature_EmbeddedExistentials


//--- A.swift
public class SomeClass {
}

//--- B.swift
public func getSomeClass() ->  SomeClass {
  return SomeClass()
}

//--- C.swift
import A
public func useMetadata() -> Any {
  return getSomeClass()
}

// Test no reference of metadata.
// A1-NOT: CMf

// Test reference of metadata. Because we are the defining module metadata is
// visible outside of the image per current policy.
// In multiple llvm modules per SIL module mode "Private" SIL linkage becomes
// hidden linkonce_odr.
// A2: @"$e1A9SomeClassCMf" = linkonce_odr hidden global
// A2: @"$e1A9SomeClassCN" = alias{{.*}}e1A9SomeClassCMf

// B2: @"$e1A9SomeClassCN" = {{.*}}external{{.*}} global
// B2: call {{.*}} @"$e1A9SomeClassCACycfC"(ptr swiftself @"$e1A9SomeClassCN")


// Test reference of metadata. Because we are the defining module metadata is
// visible outside of the image per current policy.
// In single llvm module per SIL module "Private" SIL linkage makes more
// intuitive sense.
// A3: @"$e1A9SomeClassCMf" = internal global
// A3: @"$e1A9SomeClassCN" = alias{{.*}}e1A9SomeClassCMf
// A3: call {{.*}} @"$e1A9SomeClassCACycfC"({{.*}}getelementptr{{.*}}@"$e1A9SomeClassCMf"


// Test "external" reference of metadata.
// C4: @"$e1A9SomeClassCMf" = linkonce_odr hidden global
