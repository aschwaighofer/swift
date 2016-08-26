// RUN: %target-swift-frontend -assume-parsing-unqualified-ownership-sil %s -emit-ir | %FileCheck %s

// REQUIRES: CPU=x86_64

//
// Type parameters
//
infix operator ~> { precedence 255 }

func ~> <Target, Args, Result> (
  target: Target,
  method: (Target) -> (Args) -> Result)
  -> (Args) -> Result
{
  return method(target)
}

protocol Runcible {
  associatedtype Element
}

struct Mince {}

struct Spoon: Runcible {
  typealias Element = Mince
}

func split<Seq: Runcible>(_ seq: Seq) -> ((Seq.Element) -> Bool) -> () {
  return {(isSeparator: (Seq.Element) -> Bool) in
    return ()
  }
}
var seq = Spoon()
var x = seq ~> split

//
// Indirect return
//

// CHECK-LABEL: define internal swiftcc { i8*, %swift.refcounted* } @_TPA__TF21partial_apply_generic5split{{.*}}(%V21partial_apply_generic5Spoon* noalias nocapture, %swift.refcounted* swiftself)
// CHECK:         [[REABSTRACT:%.*]] = bitcast %V21partial_apply_generic5Spoon* %0 to %swift.opaque*
// CHECK:         tail call swiftcc { i8*, %swift.refcounted* } @_TF21partial_apply_generic5split{{.*}}(%swift.opaque* noalias nocapture [[REABSTRACT]],

struct HugeStruct { var a, b, c, d: Int }
struct S {
  func hugeStructReturn(_ h: HugeStruct) -> HugeStruct { return h }
}

let s = S()
var y = s.hugeStructReturn
// CHECK-LABEL: define internal swiftcc { i64, i64, i64, i64 } @_TPA__TFV21partial_apply_generic1S16hugeStructReturnfVS_10HugeStructS1_(i64, i64, i64, i64, %swift.refcounted* swiftself) #0 {
// CHECK: entry:
// CHECK:   %5 = tail call swiftcc { i64, i64, i64, i64 } @_TFV21partial_apply_generic1S16hugeStructReturnfVS_10HugeStructS1_(i64 %0, i64 %1, i64 %2, i64 %3)
// CHECK:   ret { i64, i64, i64, i64 } %5
// CHECK: }

//
// Witness method
//
protocol Protein {
  static func veganOrNothing() -> Protein?
  static func paleoDiet() throws -> Protein
}

enum CarbOverdose : Error {
  case Mild
  case Severe
}

class Chicken : Protein {
  static func veganOrNothing() -> Protein? {
    return nil
  }

  static func paleoDiet() throws -> Protein {
    throw CarbOverdose.Severe
  }
}

func healthyLunch<T: Protein>(_ t: T) -> () -> Protein? {
  return T.veganOrNothing
}

let f = healthyLunch(Chicken())

func dietaryFad<T: Protein>(_ t: T) -> () throws -> Protein {
  return T.paleoDiet
}

let g = dietaryFad(Chicken())
do {
  try g()
} catch {}
