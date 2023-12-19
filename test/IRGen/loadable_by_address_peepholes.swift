// RUN: %target-swift-frontend %s  -O -Xllvm -sil-print-after=loadable-address -c -o %t/t.o 2>&1 | %FileCheck %s

public struct LargeThing {
    var  s0 : String = ""
    var  s1 : String = ""
    var  s2 : String = ""
    var  s3 : String = ""
    var  s4 : String = ""
    var  s5 : String = ""
    var  s6 : String = ""
    var  s7 : String = ""

    public init() {}

    mutating func setThirdString(_ to: String) {
        s2 = to
    }

    var thirdString : String {
        return s2
    }
}


public struct Container {
    public var field : LargeThing
    public var field2 : LargeThing
    //public var field : LargeThing? // Add enums to exascerbate the problem.

    public init(_ l: LargeThing, _ l2: LargeThing) {
        field = l
        field2 = l2
    }

}

public struct Container2 {
    public var field : Container
    public var field2: Container
    public var field3: LargeThing?

    public init(_ b: Bool, _ l: LargeThing, _ l2: LargeThing) {
        if b {
            let t = Container(l, l2)
            let t2 = Container(l2, l)
            field2 = t2
            field = t
            field3 = t.field
        } else {
            let t = Container(l, l2)
            let t2 = Container(l2, l)
            field = t2
            field2 = t
            field3 = t2.field2
        }
    }

    public func testLargeThing() {
        if let x = field3 {
            print("hello \(x)")
        }
    }
}

// TODO: constructors
// CHECK: sil @$s1t10LargeThingVACycfC : $@convention(method) (@thin LargeThing.Type) -> @out LargeThing {
// CHECK: bb0(%0 : $*LargeThing, %1 : $@thin LargeThing.Type):
// CHECK:   %2 = integer_literal $Builtin.Int64, 0          // user: %4
// CHECK:   %3 = integer_literal $Builtin.Int64, -2305843009213693952 // user: %5
// CHECK:   %4 = struct $UInt64 (%2 : $Builtin.Int64)       // user: %6
// CHECK:   %5 = value_to_bridge_object %3 : $Builtin.Int64 // user: %6
// CHECK:   %6 = struct $_StringObject (%4 : $UInt64, %5 : $Builtin.BridgeObject) // user: %7
// CHECK:   %7 = struct $_StringGuts (%6 : $_StringObject)  // user: %8
// CHECK:   %8 = struct $String (%7 : $_StringGuts)         // users: %9, %9, %9, %9, %9, %9, %9, %9
// CHECK:   %9 = struct $LargeThing (%8 : $String, %8 : $String, %8 : $String, %8 : $String, %8 : $String, %8 : $String, %8 : $String, %8 : $String) // user: %10
// CHECK:   store %9 to %0 : $*LargeThing                   // id: %10
// CHECK:   %11 = tuple ()                                  // user: %12
// CHECK:   return %11 : $()                                // id: %12
// CHECK: } // end sil function '$s1t10LargeThingVACycfC'


// CHECK: sil [transparent] @$s1t9ContainerV5fieldAA10LargeThingVvg : $@convention(method) (@in_guaranteed Container) -> @out LargeThing {
// CHECK: bb0(%0 : $*LargeThing, %1 : $*Container):
// CHECK:   %3 = struct_element_addr %1 : $*Container, #Container.field
// CHECK:   copy_addr %3 to [init] %0 : $*LargeThing
// CHECK:   %5 = tuple ()
// CHECK:   return %5 : $()
// CHECK: } // end sil function '$s1t9ContainerV5fieldAA10LargeThingVvg'


// CHECK: sil [transparent] @$s1t9ContainerV5fieldAA10LargeThingVvs : $@convention(method) (@in LargeThing, @inout Container) -> () {
// CHECK: bb0(%0 : $*LargeThing, %1 : $*Container):
// CHECK:  %4 = struct_element_addr %1 : $*Container, #Container.field
// CHECK:  copy_addr [take] %0 to %4 : $*LargeThing
// CHECK:  %6 = tuple ()
// CHECK:  return %6 : $()
// CHECK: } // end sil function '$s1t9ContainerV5fieldAA10LargeThingVvs'

