// RUN: %target-swift-emit-silgen -enable-sil-ownership -swift-version 5 %s | %FileCheck %s


// CHECK-LABEL: sil hidden [dynamically_replacable] @$s23dynamically_replaceable08dynamic_B0yyF : $@convention(thin) () -> () {
dynamic func dynamic_replaceable() {
}

// CHECK-LABEL: sil hidden [dynamically_replacable] @$s23dynamically_replaceable6StruktV1xACSi_tcfC : $@convention(method) (Int, @thin Strukt.Type) -> Strukt
// CHECK-LABEL: sil hidden [dynamically_replacable] @$s23dynamically_replaceable6StruktV08dynamic_B0yyF : $@convention(method) (Strukt) -> () {
struct Strukt {
  dynamic init(x: Int) {
  }
  dynamic func dynamic_replaceable() {
  }
}
// CHECK: sil hidden [dynamically_replacable] @$s23dynamically_replaceable5KlassC1xACSi_tcfC : $@convention(method) (Int, @thick Klass.Type) -> @owned Klass
// CHECK: sil hidden [dynamically_replacable] @$s23dynamically_replaceable5KlassC08dynamic_B0yyF : $@convention(method) (@guaranteed Klass) -> () {
class Klass {
  dynamic init(x: Int) {
  }
  dynamic func dynamic_replaceable() {
  }
  dynamic func dynamic_replaceable2() {
  }
}

// CHECK-LABEL: sil hidden [dynamically_replacable] @$s23dynamically_replaceable6globalSivg : $@convention(thin) () -> Int {
dynamic var global : Int {
  return 1
}

// CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable08dynamic_B0yyF"] @$s23dynamically_replaceable11replacementyyF : $@convention(thin) () -> () {
@_dynamicReplacement(for: dynamic_replaceable())
func replacement() {
}

extension Klass {
  // Calls to the replaced function inside the replacing function should be
  // statically dispatched.

  // CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable5KlassC08dynamic_B0yyF"] @$s23dynamically_replaceable5KlassC11replacementyyF : $@convention(method) (@guaranteed Klass) -> () {
  // CHECK: [[FN:%.*]] = function_ref [dynamically_replaceable_impl] @$s23dynamically_replaceable5KlassC08dynamic_B0yyF
  // CHECK: apply [[FN]](%0) : $@convention(method) (@guaranteed Klass) -> ()
  // CHECK: [[METHOD:%.*]] = class_method %0 : $Klass, #Klass.dynamic_replaceable2!1
  // CHECK: = apply [[METHOD]](%0) : $@convention(method) (@guaranteed Klass) -> ()
  // CHECK: return
  @_dynamicReplacement(for: dynamic_replaceable())
  func replacement() {
    dynamic_replaceable()
    dynamic_replaceable2()
  }

  // CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable5KlassC1xACSi_tcfC"] @$s23dynamically_replaceable5KlassC1yACSi_tcfC : $@convention(method) (Int, @thick Klass.Type) -> @owned Klass {
  // CHECK:  [[FUN:%.*]] = function_ref [dynamically_replaceable_impl] @$s23dynamically_replaceable5KlassC1xACSi_tcfC
  // CHECK:  apply [[FUN]]({{.*}}, %1)
  @_dynamicReplacement(for: init(x:))
  convenience init(y: Int) {
    self.init(x: y + 1)
  }
}

extension Strukt {

  // CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable6StruktV08dynamic_B0yyF"] @$s23dynamically_replaceable6StruktV11replacementyyF : $@convention(method) (Strukt) -> () {
  // CHECK:   [[FUN:%.*]] = function_ref [dynamically_replaceable_impl] @$s23dynamically_replaceable6StruktV08dynamic_B0yyF
  // CHECK:   apply [[FUN]](%0) : $@convention(method) (Strukt) -> ()
  @_dynamicReplacement(for: dynamic_replaceable())
  func replacement() {
    dynamic_replaceable()
  }
  // CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable6StruktV1xACSi_tcfC"] @$s23dynamically_replaceable6StruktV1yACSi_tcfC : $@convention(method) (Int, @thin Strukt.Type) -> Strukt {
  // CHECK: [[FUN:%.*]] = function_ref [dynamically_replaceable_impl] @$s23dynamically_replaceable6StruktV1xACSi_tcfC
  // CHECK: apply [[FUN]]({{.*}}, %1)
  @_dynamicReplacement(for: init(x:))
  init(y: Int) {
    self.init(x: y + 1)
  }
}
