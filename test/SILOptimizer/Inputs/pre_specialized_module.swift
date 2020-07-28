@_specialize(exported: true, where T == Int)
@_specialize(exported: true, where T == Double)
public func publicPrespecialized<T>(_ t: T) {
}

@_specialize(exported: true, where T == Int)
@_specialize(exported: true, where T == Double)
@_alwaysEmitIntoClient
internal func internalEmitIntoClientPrespecialized<T>(_ t: T) {
}

@inlinable
public func useInternalEmitIntoClientPrespecialized<T>(_ t: T) {
  internalEmitIntoClientPrespecialized(t)
}
