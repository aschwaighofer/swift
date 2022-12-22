// RUN: %target-swift-frontend -enable-relative-protocol-witness-tables -module-name A -primary-file %s -emit-ir | %FileCheck %s

// REQUIRES: CPU=x86_64 || CPU=arm64 || CPU=arm64e

protocol FuncOnly {
    func a()
    func b()
}

struct AStruct : FuncOnly {
    func a() {}
    func b() {}
}

func requireWitness<T: FuncOnly> (_ t: T) {
    t.a()
}

func useIt() {
   requireWitness(AStruct())
}

protocol Inherited : FuncOnly {
    func c()
}

struct BStruct : Inherited {
    func a() {}
    func b() {}
    func c() {}
}

func requireWitness2<T: Inherited> (_ t: T) {
    t.a()
}

func useIt2() {
    requireWitness2(BStruct())
}

// Relative protocol witness table.

// Simple Table.

// CHECK:    @"$s1A7AStructVAA8FuncOnlyAAWP" = hidden constant [3 x i32]
// CHECK-SAME: [i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_conformance_descriptor* @"$s1A7AStructVAA8FuncOnlyAAMc" to i64),
// CHECK-SAME:                      i64 ptrtoint ([3 x i32]* @"$s1A7AStructVAA8FuncOnlyAAWP" to i64)) to i32),
// CHECK-SAME:  i32 trunc (i64 sub (i64 ptrtoint (void (%T1A7AStructV*, %swift.type*, i8**)* @"$s1A7AStructVAA8FuncOnlyA2aDP1ayyFTW" to i64),
// CHECK-SAME:                      i64 ptrtoint (i32* getelementptr inbounds ([3 x i32], [3 x i32]* @"$s1A7AStructVAA8FuncOnlyAAWP", i32 0, i32 1) to i64)) to i32),
// CHECK-SAME:  i32 trunc (i64 sub (i64 ptrtoint (void (%T1A7AStructV*, %swift.type*, i8**)* @"$s1A7AStructVAA8FuncOnlyA2aDP1byyFTW" to i64),
// CHECK-SAME:                      i64 ptrtoint (i32* getelementptr inbounds ([3 x i32], [3 x i32]* @"$s1A7AStructVAA8FuncOnlyAAWP", i32 0, i32 2) to i64)) to i32)
// CHECK-SAME: ], align 8

// Simple Table with parent.

// CHECK: @"$s1A7BStructVAA9InheritedAAWP" = hidden constant [3 x i32]
// CHECK-SAME: [i32 trunc (i64 sub (i64 ptrtoint (%swift.protocol_conformance_descriptor* @"$s1A7BStructVAA9InheritedAAMc" to i64),
// CHECK-SAME:                      i64 ptrtoint ([3 x i32]* @"$s1A7BStructVAA9InheritedAAWP" to i64)) to i32),
// CHECK-SAME:  i32 trunc (i64 sub (i64 ptrtoint ([3 x i32]* @"$s1A7BStructVAA8FuncOnlyAAWP" to i64),
// CHECK-SAME:                      i64 ptrtoint (i32* getelementptr inbounds ([3 x i32], [3 x i32]* @"$s1A7BStructVAA9InheritedAAWP", i32 0, i32 1) to i64)) to i32),
// CHECK-SAME   i32 trunc (i64 sub (i64 ptrtoint (void (%T1A7BStructV*, %swift.type*, i8**)* @"$s1A7BStructVAA9InheritedA2aDP1cyyFTW" to i64),
// CHECK-SAME:                      i64 ptrtoint (i32* getelementptr inbounds ([3 x i32], [3 x i32]* @"$s1A7BStructVAA9InheritedAAWP", i32 0, i32 2) to i64)) to i32)
// CHECK-SAME: ], align 8

// Simple witness entry access.

// CHECK: define{{.*}} swiftcc void @"$s1A14requireWitnessyyxAA8FuncOnlyRzlF"(%swift.opaque* noalias nocapture {{%.*}}, %swift.type* {{%.*}}, i8** [[PWT:%.*]])
// CHECK:   [[CAST:%.*]] = bitcast i8** [[PWT]] to i32*
// CHECK:   [[SLOT:%.*]] = getelementptr inbounds i32, i32* [[CAST]], i32 1
// CHECK:   [[T0:%.*]] = load i32, i32* [[SLOT]], align 4
// CHECK:   [[T1:%.*]] = sext i32 [[T0]] to i64
// CHECK:   [[T2:%.*]] = ptrtoint i32* [[SLOT]] to i64
// CHECK:   [[T3:%.*]] = add i64 [[T2]], [[T1]]
// CHECK:   [[T4:%.*]] = inttoptr i64 [[T3]] to i8*
// CHECK:   [[T5:%.*]] = bitcast i8* [[T4]] to void (%swift.opaque*, %swift.type*, i8**)*
// CHECK:   call{{.*}} swiftcc void [[T5]]

// Parent witness entry access.

// CHECK: define hidden swiftcc void @"$s1A15requireWitness2yyxAA9InheritedRzlF"(%swift.opaque* noalias nocapture {{%.*}}, %swift.type* {{%.*}}, i8** [[T_INHERITED:%.*]])
// CHECK:   [[T0:%.*]] = bitcast i8** [[T_INHERITED]] to i32*
// CHECK:   [[T1:%.*]] = getelementptr inbounds i32, i32* [[T0]], i32 1
// CHECK:   [[T2:%.*]] = load i32, i32* [[T1]], align 4
// CHECK:   [[T3:%.*]] = sext i32 [[T2]] to i64
// CHECK:   [[T4:%.*]] = ptrtoint i32* [[T1]] to i64
// CHECK:   [[T5:%.*]] = add i64 [[T4]], [[T3]]
// CHECK:   [[T6:%.*]] = inttoptr i64 [[T5]] to i8*
// CHECK:   [[T_FUNCONLY:%.*]] = bitcast i8* [[T6]] to i8**
// CHECK:   [[T7:%.*]] = bitcast i8** [[T_FUNCONLY]] to i32*
// CHECK:   [[T8:%.*]] = getelementptr inbounds i32, i32* [[T7]], i32 1
// CHECK:   [[T9:%.*]] = load i32, i32* [[T8]], align 4
// CHECK:   [[T10:%.*]] = sext i32 [[T9]] to i64
// CHECK:   [[T11:%.*]] = ptrtoint i32* [[T8]] to i64
// CHECK:   [[T12:%.*]] = add i64 [[T11]], [[T10]]
// CHECK:   [[T13:%.*]] = inttoptr i64 [[T12]] to i8*
// CHECK:   [[T14:%.*]] = bitcast i8* [[T13]] to void (%swift.opaque*, %swift.type*, i8**)*
// CHECK:   call{{.*}} swiftcc void [[T14]]

// Passing the witness table.

// CHECK: define{{.*}} swiftcc void @"$s1A6useIt2yyF"()
// CHECK:   call swiftcc void @"$s1A15requireWitness2yyxAA9InheritedRzlF"(%swift.opaque* {{.*}}, %swift.type* {{.*}} @"$s1A7BStructVMf"{{.*}}, i8** {{.*}} @"$s1A7BStructVAA9InheritedAAWP"{{.*}})
// CHECK:   ret void
