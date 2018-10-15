// RUN: %target-swift-emit-silgen -enable-sil-ownership -swift-version 5 %s | %FileCheck %s


// CHECK-LABEL: sil hidden [dynamically_replacable] @$s23dynamically_replaceable08dynamic_B0yyF : $@convention(thin) () -> () {
dynamic func dynamic_replaceable() {
}

// CHECK-LABEL: sil hidden [dynamically_replacable] @$s23dynamically_replaceable6StruktV1xACSi_tcfC : $@convention(method) (Int, @thin Strukt.Type) -> Strukt
// CHECK-LABEL: sil hidden [dynamically_replacable] @$s23dynamically_replaceable6StruktV08dynamic_B0yyF : $@convention(method) (Strukt) -> () {
// CHECK-LABEL: sil hidden [dynamically_replacable] @$s23dynamically_replaceable6StruktV08dynamic_B4_varSivg
// CHECK-LABEL: sil hidden [dynamically_replacable] @$s23dynamically_replaceable6StruktV08dynamic_B4_varSivs
// CHECK-LABEL: sil hidden [dynamically_replacable] @$s23dynamically_replaceable6StruktVyS2icig : $@convention(method) (Int, Strukt) -> Int
// CHECK-LABEL: sil hidden [dynamically_replacable] @$s23dynamically_replaceable6StruktVyS2icis : $@convention(method) (Int, Int, @inout Strukt) -> ()
struct Strukt {
  dynamic init(x: Int) {
  }
  dynamic func dynamic_replaceable() {
  }

  dynamic var dynamic_replaceable_var : Int {
    get {
      return 10
    }
    set {
    }
  }

  dynamic subscript(x : Int) -> Int {
    get {
      return 10
    }
    set {
    }
  }
}
// CHECK-LABEL: sil hidden [dynamically_replacable] @$s23dynamically_replaceable5KlassC1xACSi_tcfC : $@convention(method) (Int, @thick Klass.Type) -> @owned Klass
// CHECK-LABEL: sil hidden [dynamically_replacable] @$s23dynamically_replaceable5KlassC08dynamic_B0yyF : $@convention(method) (@guaranteed Klass) -> () {
// CHECK-LABEL: sil hidden [dynamically_replacable] @$s23dynamically_replaceable5KlassC08dynamic_B4_varSivg
// CHECK-LABEL: sil hidden [dynamically_replacable] @$s23dynamically_replaceable5KlassC08dynamic_B4_varSivs
// CHECK-LABEL: sil hidden [dynamically_replacable] @$s23dynamically_replaceable5KlassCyS2icig : $@convention(method) (Int, @guaranteed Klass) -> Int
// CHECK_LABEL: sil hidden [dynamically_replacable] @$s23dynamically_replaceable5KlassCyS2icis : $@convention(method) (Int, Int, @guaranteed Klass) -> ()
class Klass {
  dynamic init(x: Int) {
  }
  dynamic func dynamic_replaceable() {
  }
  dynamic func dynamic_replaceable2() {
  }
  dynamic var dynamic_replaceable_var : Int {
    get {
      return 10
    }
    set {
    }
  }
  dynamic subscript(x : Int) -> Int {
    get {
      return 10
    }
    set {
    }
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

// CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable5KlassC08dynamic_B4_varSivg"] @$s23dynamically_replaceable5KlassC1rSivg : $@convention(method) (@guaranteed Klass) -> Int {
// CHECK: bb0([[ARG:%.*]] : @guaranteed $Klass):
// CHECK:   [[ORIG:%.*]] = function_ref [dynamically_replaceable_impl] @$s23dynamically_replaceable5KlassC08dynamic_B4_varSivg
// CHECK:   apply [[ORIG]]([[ARG]]) : $@convention(method) (@guaranteed Klass) -> Int

// CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable5KlassC08dynamic_B4_varSivs"] @$s23dynamically_replaceable5KlassC1rSivs : $@convention(method) (Int, @guaranteed Klass) -> () {
// CHECK: bb0({{.*}} : @trivial $Int, [[SELF:%.*]] : @guaranteed $Klass):
// CHECK:   [[ORIG:%.*]] = function_ref [dynamically_replaceable_impl] @$s23dynamically_replaceable5KlassC08dynamic_B4_varSivs
// CHECK:   apply [[ORIG]]({{.*}}, [[SELF]]) : $@convention(method)
  @_dynamicReplacement(for: dynamic_replaceable_var)
  var r : Int {
    get {
      return dynamic_replaceable_var + 1
    }
    set {
      dynamic_replaceable_var = newValue + 1
    }
  }

// CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable5KlassCyS2icig"] @$s23dynamically_replaceable5KlassC1xS2i_tcig
// CHECK: bb0({{.*}} : @trivial $Int, [[SELF:%.*]] : @guaranteed $Klass):
// CHECK:   [[ORIG:%.*]] = function_ref [dynamically_replaceable_impl] @$s23dynamically_replaceable5KlassCyS2icig
// CHECK:   apply [[ORIG]]({{.*}}, [[SELF]]) : $@convention(method) (Int, @guaranteed Klass) -> Int

// CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable5KlassCyS2icis"] @$s23dynamically_replaceable5KlassC1xS2i_tcis
// CHECK: bb0({{.*}} : @trivial $Int, {{.*}} : @trivial $Int, [[SELF:%.*]] : @guaranteed $Klass):
// CHECK:   [[ORIG:%.*]] = function_ref [dynamically_replaceable_impl] @$s23dynamically_replaceable5KlassCyS2icis
// CHECK:   apply [[ORIG]]({{.*}}, {{.*}}, [[SELF]]) : $@convention(method) (Int, Int, @guaranteed Klass) -> ()

  @_dynamicReplacement(for: subscript(_:))
  subscript(x y: Int) -> Int {
    get {
      return self[y]
    }
    set {
      self[y] = newValue
    }
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

// CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable6StruktV08dynamic_B4_varSivg"] @$s23dynamically_replaceable6StruktV1rSivg
// CHECK: bb0([[ARG:%.*]] : @trivial $Strukt):
// CHECK:   [[ORIG:%.*]] = function_ref [dynamically_replaceable_impl] @$s23dynamically_replaceable6StruktV08dynamic_B4_varSivg
// CHECK:   apply [[ORIG]]([[ARG]]) : $@convention(method) (Strukt) -> Int

// CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable6StruktV08dynamic_B4_varSivs"] @$s23dynamically_replaceable6StruktV1rSivs
// CHECK: bb0({{.*}} : @trivial $Int, [[ARG:%.*]] : @trivial $*Strukt):
// CHECK:   [[BA:%.*]] = begin_access [modify] [unknown] [[ARG]] : $*Strukt
// CHECK:   [[ORIG:%.*]] = function_ref [dynamically_replaceable_impl] @$s23dynamically_replaceable6StruktV08dynamic_B4_varSivs
// CHECK:   apply [[ORIG]]({{.*}}, [[BA]]) : $@convention(method) (Int, @inout Strukt) -> ()
// CHECK:   end_access [[BA]] : $*Strukt
  @_dynamicReplacement(for: dynamic_replaceable_var)
  var r : Int {
    get {
      return dynamic_replaceable_var + 1
    }
    set {
      dynamic_replaceable_var = newValue + 1
    }
  }

// CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable6StruktVyS2icig"] @$s23dynamically_replaceable6StruktV1xS2i_tcig
// CHECK: bb0({{.*}} : @trivial $Int, [[SELF:%.*]] : @trivial $Strukt):
// CHECK:   [[ORIG:%.*]] = function_ref [dynamically_replaceable_impl] @$s23dynamically_replaceable6StruktVyS2icig
// CHECK:   apply [[ORIG]]({{.*}}, [[SELF]]) : $@convention(method) (Int, Strukt) -> Int

// CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable6StruktVyS2icis"] @$s23dynamically_replaceable6StruktV1xS2i_tcis
// CHECK: bb0({{.*}} : @trivial $Int, {{.*}} : @trivial $Int, [[SELF:%.*]] : @trivial $*Strukt):
// CHECK:   [[BA:%.*]] = begin_access [modify] [unknown] [[SELF]] : $*Strukt
// CHECK:   [[ORIG:%.*]] = function_ref [dynamically_replaceable_impl] @$s23dynamically_replaceable6StruktVyS2icis
// CHECK:   apply [[ORIG]]({{.*}}, {{.*}}, [[BA]]) : $@convention(method) (Int, Int, @inout Strukt) -> ()
// CHECK:   end_access [[BA]] : $*Strukt

 @_dynamicReplacement(for: subscript(_:))
 subscript(x y: Int) -> Int {
    get {
      return self[y]
    }
    set {
      self[y] = newValue
    }
  }
}


struct GenericS<T> {
  dynamic init(x: Int) {
  }
  dynamic func dynamic_replaceable() {
  }

  dynamic var dynamic_replaceable_var : Int {
    get {
      return 10
    }
    set {
    }
  }

  dynamic subscript(x : Int) -> Int {
    get {
      return 10
    }
    set {
    }
  }
}

extension GenericS {

// CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable8GenericSV08dynamic_B0yyF"] @$s23dynamically_replaceable8GenericSV11replacementyyF
// CHECK: function_ref [dynamically_replaceable_impl] @$s23dynamically_replaceable8GenericSV08dynamic_B0yyF
  @_dynamicReplacement(for: dynamic_replaceable())
  func replacement() {
    dynamic_replaceable()
  }
// CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable8GenericSV1xACyxGSi_tcfC"] @$s23dynamically_replaceable8GenericSV1yACyxGSi_tcfC
// CHECK: function_ref [dynamically_replaceable_impl] @$s23dynamically_replaceable8GenericSV1xACyxGSi_tcfC
  @_dynamicReplacement(for: init(x:))
  init(y: Int) {
    self.init(x: y + 1)
  }

// CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable8GenericSV08dynamic_B4_varSivg"] @$s23dynamically_replaceable8GenericSV1rSivg
// CHECK: function_ref [dynamically_replaceable_impl] @$s23dynamically_replaceable8GenericSV08dynamic_B4_varSivg

// CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable8GenericSV08dynamic_B4_varSivs"] @$s23dynamically_replaceable8GenericSV1rSivs
// CHECK: function_ref [dynamically_replaceable_impl] @$s23dynamically_replaceable8GenericSV08dynamic_B4_varSivs
  @_dynamicReplacement(for: dynamic_replaceable_var)
  var r : Int {
    get {
      return dynamic_replaceable_var + 1
    }
    set {
      dynamic_replaceable_var = newValue + 1
    }
  }

// CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable8GenericSVyS2icig"] @$s23dynamically_replaceable8GenericSV1xS2i_tcig
// CHECK: function_ref [dynamically_replaceable_impl] @$s23dynamically_replaceable8GenericSVyS2icig

// CHECK-LABEL: sil hidden [dynamic_replacement_for "$s23dynamically_replaceable8GenericSVyS2icis"] @$s23dynamically_replaceable8GenericSV1xS2i_tcis
// CHECK: function_ref [dynamically_replaceable_impl] @$s23dynamically_replaceable8GenericSVyS2icis
 @_dynamicReplacement(for: subscript(_:))
 subscript(x y: Int) -> Int {
    get {
      return self[y]
    }
    set {
      self[y] = newValue
    }
  }
}
