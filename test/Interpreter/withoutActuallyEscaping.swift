// RUN: %target-run-simple-swift
// REQUIRES: executable_test

import StdlibUnittest

var WithoutEscapingSuite = TestSuite("WithoutActuallyEscaping")

var sink: Any = ()

func dontEscape(f: () -> ()) {
  withoutActuallyEscaping(f) {
    $0()
  }
}

func letEscape(f: () -> ()) -> () -> () {
  return withoutActuallyEscaping(f) { return $0 }
}

WithoutEscapingSuite.test("ExpectNoCrash") {
  dontEscape(f: { print("foo") })
}

WithoutEscapingSuite.test("ExpectDebugCrash") {
  // Optimize versions pass a nil closure context.
  if _isDebugAssertConfiguration() {
    expectCrashLater()
  }
  sink = letEscape(f: { print("foo") })
}

struct Context {
  var a = 0
  var b = 1
}

WithoutEscapingSuite.test("ExpectCrash") {
  expectCrashLater()
  let context = Context()
  sink = letEscape(f: { print("Context: \(context.a) \(context.b)") })
}

runAllTests()
