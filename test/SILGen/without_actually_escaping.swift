// RUN: %target-swift-frontend -emit-silgen -enable-sil-ownership %s | %FileCheck %s

var escapeHatch: Any = 0

// CHECK-LABEL: sil hidden @$S25without_actually_escaping9letEscape1fyycyyXE_tF
func letEscape(f: () -> ()) -> () -> () {
// CHECK: bb0([[ARG:%.*]] : @trivial $@noescape @callee_guaranteed () -> ()):
// CHECK:  [[CVT:%.*]] = function_ref @$SIg_Ieg_TR : $@convention(thin) (@noescape @callee_guaranteed () -> ()) -> ()
// TODO: verify that the partial_apply's reference count is one at the end of the scope.
// CHECK:  [[CLOSURE:%.*]] = partial_apply [callee_guaranteed] [[CVT]]([[ARG]]) : $@convention(thin) (@noescape @callee_guaranteed () -> ()) -> ()
// CHECK:  [[MD:%.*]] = mark_dependence  [[CLOSURE]] : $@callee_guaranteed () -> () on [[ARG]] : $@noescape @callee_guaranteed () -> ()
// CHECK:  [[COPY:%.*]] = copy_value [[MD]] : $@callee_guaranteed () -> ()
// CHECK:  [[USER:%.*]] = function_ref @$S25without_actually_escaping9letEscape1fyycyyXE_tFyycyycXEfU_ : $@convention(thin) (@owned @callee_guaranteed () -> ()) -> @owned @callee_guaranteed () -> ()
// CHECK:  [[RES:%.*]] = apply [[USER]]([[COPY]]) : $@convention(thin) (@owned @callee_guaranteed () -> ()) -> @owned @callee_guaranteed () -> ()
// CHECK:  [[BORROW:%.*]] = begin_borrow [[MD]] : $@callee_guaranteed () -> ()
// CHECK:  [[ESCAPED:%.*]] = is_escaping_closure [[BORROW]] : $@callee_guaranteed () -> ()
// CHECK:  end_borrow [[BORROW]] from [[MD]] : $@callee_guaranteed () -> (), $@callee_guaranteed () -> ()
// CHECK:  cond_fail [[ESCAPED]] : $Builtin.Int1
// CHECK:  destroy_value [[MD]]
// CHECK:  return [[RES]] : $@callee_guaranteed () -> ()
  return withoutActuallyEscaping(f) { return $0 }
}
