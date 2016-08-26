import Foundation
@_exported import AppKit

// Fix the ARGV type of NSApplicationMain, which nonsensically takes
// argv as a const char**.
@_silgen_name("NSApplicationMainSwift")
public func NSApplicationMain(
  _ argc: Int32, _ argv: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>
) -> Int32 {
  return argv.withMemoryRebound(to:UnsafePointer<Int8>.self, capacity: Int(argc)) {
    argv in
    return NSApplicationMain(argc, argv)
  })
}
