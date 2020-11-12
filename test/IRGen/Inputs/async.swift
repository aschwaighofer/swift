public class SomeClass {}

public func asyncEntry() async -> () {
  var lifeAccross = 666
  var c = SomeClass()
  await callHello()
  await callReturnSomething()
  await useAsyncClosure(c)
  print("lifeAccross: \(lifeAccross)")
  let closure = await createAsyncClosure(5)
  await closure()
}

public func hello(_ p: Int) async {
  print("hello\(p)")
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
