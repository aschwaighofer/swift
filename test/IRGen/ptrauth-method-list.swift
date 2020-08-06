// FIXME [relative-method-list-staging]: Once the feature has completed staging, we can remove the -Xcc -Xclang
// RUN: %target-swift-frontend %s -target arm64e-apple-ios13.0 -parse-stdlib -parse-as-library -Xcc -Xclang -Xcc -fptrauth-calls -module-name tmp -emit-ir -o - | %FileCheck %s --check-prefix=IR-BEFORE
// RUN: %target-swift-frontend %s -target arm64e-apple-ios13.0 -parse-stdlib -parse-as-library -Xcc -Xclang -Xcc -fptrauth-calls -Xcc -Xclang -Xcc -fexperimental-objc-rr-method-list -module-name tmp -emit-ir -o - |  %FileCheck %s --check-prefix=IR-AFTER

// REQUIRES: CPU=arm64e
// REQUIRES: OS=ios

import Foundation

@objc
public class X : NSObject {
  @objc
  public func x() {}
}

// Using relative references means we don't need signed pointers to the method implementations.
// IR-BEFORE:    @"$s3tmp1XC1xyyFTo.ptrauth"
// IR-AFTER-NOT: @"$s3tmp1XC1xyyFTo.ptrauth"
// IR-BEFORE:    @"$s3tmp1XCACycfcTo.ptrauth"
// IR-AFTER-NOT: @"$s3tmp1XCACycfcTo.ptrauth"

// IR-BEFORE: @_INSTANCE_METHODS__TtC3tmp1X
// IR-AFTER:  @_INSTANCE_METHODS__TtC3tmp1X

// The size of the method descriptor shrinks from 24 to 12.
// -2147483636 == 12 | (1 << 31) to indicate that the descriptor has relative references.
// IR-BEFORE: i32 24, i32 2, [2 x { i8*, i8*, i8* }]
// IR-AFTER:  i32 -2147483636, i32 2, [2 x { i32, i32, i32 }]

// Relative references are put in immutable memory.
// IR-BEFORE: section "__DATA, __objc_const"
// IR-AFTER:  section "__TEXT, __objc_methlist"

// IR-BEFORE: @_DATA__TtC3tmp1X
// IR-AFTER:  @_DATA__TtC3tmp1X

// The metadata type is updated to reflect the new method descriptor type.
// IR-BEFORE: { i32, i32, [2 x { i8*, i8*, i8* }] }*
// IR-AFTER:  { i32, i32, [2 x { i32, i32, i32 }] }*

// The metadata itself is still in __DATA.
// IR-BEFORE: section "__DATA, __objc_const"
// IR-AFTER:  section "__DATA, __objc_const"

extension X {
  @objc
  public func this() -> X {
    return self
  }
}

// Relative references work for extensions too!

// IR-BEFORE:    @"$s3tmp1XC4thisACyFTo.ptrauth"
// IR-AFTER-NOT: @"$s3tmp1XC4thisACyFTo.ptrauth"

// IR-BEFORE: @"_CATEGORY_INSTANCE_METHODS__TtC3tmp1X_$_tmp"
// IR-AFTER:  @"_CATEGORY_INSTANCE_METHODS__TtC3tmp1X_$_tmp"

// IR-BEFORE: i32 24, i32 1, [1 x { i8*, i8*, i8* }]
// IR-AFTER:  i32 -2147483636, i32 1, [1 x { i32, i32, i32 }]

// IR-BEFORE: section "__DATA, __objc_const"
// IR-AFTER:  section "__TEXT, __objc_methlist"

// IR-BEFORE: @"_CATEGORY__TtC3tmp1X_$_tmp"
// IR-AFTER:  @"_CATEGORY__TtC3tmp1X_$_tmp"

// IR-BEFORE: { i32, i32, [1 x { i8*, i8*, i8* }] }*
// IR-AFTER:  { i32, i32, [1 x { i32, i32, i32 }] }*

// IR-BEFORE: section "__DATA, __objc_const"
// IR-AFTER:  section "__DATA, __objc_const"
