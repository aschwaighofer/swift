// RUN: %target-swift-frontend -emit-silgen -enable-sil-ownership %s | %FileCheck %s

var escapeHatch: Any = 0

// CHECK-LABEL: sil hidden @$S25without_actually_escaping9letEscape1fyycyyc_tF
// CHECK:   bb0([[ARG:%.*]] : @trivial $@noescape @callee_guaranteed () -> ()):
// CHECK:   [[THUNK:%.*]] = function_ref @$SIg_Ieg_TR : $@convention(thin) (@guaranteed @noescape @callee_guaranteed () -> ()) -> ()
// CHECK:   [[ESC:%.*]] = partial_apply [callee_guaranteed] [[THUNK]]([[ARG]]) : $@convention(thin) (@guaranteed @noescape @callee_guaranteed () -> ()) -> ()
// CHECK:   [[ESC2:%.*]] = mark_dependence [[ESC]] : $@callee_guaranteed () -> () on  [[ARG]] : $@noescape @callee_guaranteed () -> ()
// CHECK:   [[USE:%.*]] = function_ref @$S25without_actually_escaping9letEscape1fyycyyc_tFyycyyccfU_ : $@convention(thin) (@owned @callee_guaranteed () -> ()) -> @owned @callee_guaranteed () -> ()
// CHECK:   [[R:%.*]] = apply [[USE]]([[ESC2]]) : $@convention(thin) (@owned @callee_guaranteed () -> ()) -> @owned @callee_guaranteed () -> ()
// CHECK:   return [[R]] : $@callee_guaranteed () -> ()
func letEscape(f: () -> ()) -> () -> () {
  return withoutActuallyEscaping(f) { return $0 }
}
