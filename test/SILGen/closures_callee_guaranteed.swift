// RUN: %target-swift-frontend -enable-sil-ownership -parse-stdlib -parse-as-library  -emit-silgen %s | %FileCheck %s
import Swift

public class T {
  public func val() -> Int { return 1 }
}

// CHECK-LABEL: sil @{{.*}}apply{{.*}} : $@convention(thin) (@noescape @callee_guaranteed () -> Int) -> Int
// CHECK: bb0([[T1:%.*]] : @trivial $@noescape @callee_guaranteed () -> Int):
// CHECK-NOT: copy_value
// CHECK:   [[R:%.*]] = apply [[T1]]() : $@noescape @callee_guaranteed () -> Int
// CHECK-NOT: destroy_value
// CHECK:   return [[R]] : $Int
public func apply(_ f : () -> Int) -> Int {
  return f()
}

// CHECK-LABEL: sil @{{.*}}test{{.*}} : $@convention(thin) () -> ()
// CHECK:   [[C1:%.*]] = function_ref @{{.*}}test{{.*}} : $@convention(thin) () -> Int
// CHECK:   [[C2:%.*]] = thin_to_thick_function [[C1]] : $@convention(thin) () -> Int to $@noescape @callee_guaranteed () -> Int
// CHECK:   [[A:%.*]] = function_ref @{{.*}}apply{{.*}} : $@convention(thin) (@noescape @callee_guaranteed () -> Int) -> Int
// CHECK:   apply [[A]]([[C2]]) : $@convention(thin) (@noescape @callee_guaranteed () -> Int) -> Int
public func test() {
  let res = apply({ return 1 })
}

// CHECK-LABEL: sil @{{.*}}test2{{.*}} : $@convention(thin) (@owned T) -> () {
// CHECK: bb0([[PARAM:%.*]] : @owned $T):
// CHECK:   [[CF:%.*]] = function_ref @{{.*}}test2{{.*}} : $@convention(thin) (@guaranteed T) -> Int
// CHECK:   [[CAP:%.*]] = copy_value [[PARAM]]
// CHECK:   [[ESC:%.*]] = partial_apply [callee_guaranteed] [[CF]]([[CAP]])
// CHECK:   [[B:%.*]] = begin_borrow [[ESC]] : $@callee_guaranteed () -> Int
// CHECK:   [[TRIV:%.*]] = convert_function_to_trivial [[B]] : $@callee_guaranteed () -> Int to $@noescape @callee_guaranteed () -> Int
// CHECK:   [[NE:%.*]] = mark_dependence [[TRIV]] : $@noescape @callee_guaranteed () -> Int on [[B]] : $@callee_guaranteed () -> Int
// CHECK:   [[AP:%.*]] = function_ref @{{.*}}apply{{.*}} : $@convention(thin) (@noescape @callee_guaranteed () -> Int) -> Int
// CHECK:   apply [[AP]]([[NE]]) : $@convention(thin) (@noescape @callee_guaranteed () -> Int) -> Int
// CHECK:   end_borrow [[B]] from [[ESC]] : $@callee_guaranteed () -> Int, $@callee_guaranteed () -> Int
// CHECK:   destroy_value [[ESC]] : $@callee_guaranteed () -> Int
// CHECK:   destroy_value [[PARAM]] : $T
// CHECK:   [[T:%.*]] = tuple ()
// CHECK:   return [[T]] : $()
public func test2(_ t: T) {
  let res = apply({ return t.val() })
}

// CHECK-LABEL: sil @{{.*}}applyEscaping{{.*}} : $@convention(thin) (@owned @callee_guaranteed () -> Int) -> Int {
// CHECK: bb0([[ARG:%.*]] : @owned $@callee_guaranteed () -> Int):
// CHECK:   [[B1:%.*]] = begin_borrow %0 : $@callee_guaranteed () -> Int
// CHECK:   [[COPY:%.*]] = copy_value [[B1]] : $@callee_guaranteed () -> Int
// CHECK:   [[B2:%.*]] = begin_borrow %3 : $@callee_guaranteed () -> Int
// CHECK:   [[RES:%.*]] = apply [[B2]]() : $@callee_guaranteed () -> Int
// CHECK:   end_borrow [[B2]] from [[COPY]] : $@callee_guaranteed () -> Int, $@callee_guaranteed () -> Int
// CHECK:   destroy_value [[COPY]] : $@callee_guaranteed () -> Int
// CHECK:   end_borrow [[B1]] from [[ARG]] : $@callee_guaranteed () -> Int, $@callee_guaranteed () -> Int
// CHECK:   destroy_value [[ARG]] : $@callee_guaranteed () -> Int
// CHECK:   return [[RES]] : $Int
public func applyEscaping(_ e: @escaping () -> Int) -> Int {
  return e()
}
