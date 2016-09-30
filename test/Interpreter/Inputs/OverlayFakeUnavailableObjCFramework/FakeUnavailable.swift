@_exported import FakeUnavailableObjCFramework

@available(OSX 1066.0, iOS 1066.0, watchOS 1066.0, tvOS 1066.0, *)
extension UnavailableObjCClass {
   public class var foo:  Set<UnavailableNSInteger> {
     return Set() 
   }
}

