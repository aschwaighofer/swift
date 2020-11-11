// RUN: %target-swift-frontend -primary-file %s -emit-ir -enable-experimental-concurrency | %FileCheck %s

// REQUIRES: concurrency

// CHECK: "$s5async1fyyYF"
public func f() async { }

// CHECK: "$s5async1gyyYKF"
public func g() async throws { }

public func hello(_ p: Int) async {
  print("hello")
}

public func callHello() async {
  await hello(5)
}

public func returnSomething(_ p: Int) async -> Int {
  return p
}

public func callReturnSomething() async {
  let x = await returnSomething(5)
  print(x)
  let y = await returnSomething(6)
  print(y)
}

public func callAsyncClosure(_ closure : () async->()) async {
  await closure()
}

public class SomeClass {}

internal func aPrivateAsync(_ x: Int) async -> Int {
  return x
}

public func useAsyncClosure(_ c: SomeClass) async {
  func closure() async {
    print(c)
  }
  await callAsyncClosure(closure)
}

public func createAsyncClosure<T>(_ t: T) async -> () async -> () {
  func closure() async {
    print(t)
  }
  return closure
}
