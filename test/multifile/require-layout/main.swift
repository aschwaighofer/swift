// RUN: %empty-directory(%t)
// RUN: %target-build-swift %S/../require-layout-generic-arg.swift %S/../Inputs/require-layout-generic-class.swift %s -o %t/test
// RUN: %target-run %t/test | %FileCheck %s

func test() {
  requestType(Sub(1))
}

// CHECK: Int
test()
