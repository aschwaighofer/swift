// RUN: %target-swift-frontend -enable-relative-protocol-witness-tables -module-name A -primary-file %s -emit-ir | %FileCheck %s

// REQUIRES: CPU=x86_64 || CPU=arm64 || CPU=arm64e

// Simple case.
protocol FuncOnly {
    func a()
    func b()
}


struct AStruct : FuncOnly {
    func a() {}
    func b() {}
}

// Relative protocol witness table.

// CHECK:    @"$s1A7AStructVAA8FuncOnlyAAWP" = hidden constant [3 x i32] 
// CHECK-SAME: [i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_conformance_descriptor* @"$s1A7AStructVAA8FuncOnlyAAMc" to i64),
// CHECK-SAME:                      i64 ptrtoint ([3 x i32]* @"$s1A7AStructVAA8FuncOnlyAAWP" to i64)) to i32),
// CHECK-SAME:  i32 trunc (i64 sub (i64 ptrtoint (void (%T1A7AStructV*, %swift.type*, i8**)* @"$s1A7AStructVAA8FuncOnlyA2aDP1ayyFTW" to i64),
// CHECK-SAME:                      i64 ptrtoint (i32* getelementptr inbounds ([3 x i32], [3 x i32]* @"$s1A7AStructVAA8FuncOnlyAAWP", i32 0, i32 1) to i64)) to i32),
// CHECK-SAME:  i32 trunc (i64 sub (i64 ptrtoint (void (%T1A7AStructV*, %swift.type*, i8**)* @"$s1A7AStructVAA8FuncOnlyA2aDP1byyFTW" to i64),
// CHECK-SAME:                      i64 ptrtoint (i32* getelementptr inbounds ([3 x i32], [3 x i32]* @"$s1A7AStructVAA8FuncOnlyAAWP", i32 0, i32 2) to i64)) to i32)
// CHECK-SAME: ], align 8


func requireWitness<T: FuncOnly> (_ t: T) {
    t.a()
}

// CHECK: define{{.*}} swiftcc void @"$s1A14requireWitnessyyxAA8FuncOnlyRzlF"(%swift.opaque* noalias nocapture %0, %swift.type* %T, i8** [[PWT:%.*]])
// CHECK:   [[CAST:%.*]] = bitcast i8** [[PWT]] to i32*
// CHECK:   [[SLOT:%.*]] = getelementptr inbounds i32, i32* [[CAST]], i32 1
// CHECK:   [[T0:%.*]] = load i32, i32* [[SLOT]], align 4
// CHECK:   [[T1:%.*]] = sext i32 [[T0]] to i64
// CHECK:   [[T2:%.*]] = ptrtoint i32* [[SLOT]] to i64
// CHECK:   [[T3:%.*]] = add i64 [[T2]], [[T1]]
// CHECK:   [[T4:%.*]] = inttoptr i64 [[T3]] to i8*
// CHECK:   [[T5:%.*]] = bitcast i8* [[T4]] to void (%swift.opaque*, %swift.type*, i8**)*
// CHECK:   call swiftcc void [[T5]]

func useIt() {
   requireWitness(AStruct())
}
