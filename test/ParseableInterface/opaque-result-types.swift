// RUN: %target-swift-frontend -typecheck -emit-parseable-module-interface-path - %s | %FileCheck %s

public protocol Foo {}
extension Int: Foo {}

// CHECK-LABEL: @_opaqueReturnTypeDecl(
// CHECK-SAME:     [[OPAQUE_DECL:.*]]) public func foo(_: Int) -> some Foo
// CHECK-NEXT:  public __opaque_type [[OPAQUE_DECL]] -> <[[ARG:.*]]> [[ARG]] where [[ARG]] : Foo
public func foo(_: Int) -> some Foo {
  return 1738
}

// CHECK-LABEL: @_opaqueReturnTypeDecl(
// CHECK-SAME:     [[OPAQUE_DECL:.*]]) @inlinable public func foo(_: String) -> some Foo {
// CHECK:       }
// CHECK-NEXT:  public __opaque_type [[OPAQUE_DECL]] -> <[[ARG:.*]]> [[ARG]] where [[ARG]] : Foo
@inlinable public func foo(_: String) -> some Foo {
  return 679
}

// CHECK-LABEL: @_opaqueReturnTypeDecl(
// CHECK-SAME:     [[OPAQUE_DECL:.*]]) public func foo<T>(_ x: T) -> some Foo where T : Foo
// CHECK-NEXT:  public __opaque_type [[OPAQUE_DECL]]<[[IN_ARG:.*]]> -> <[[OUT_ARG:.*]]> [[OUT_ARG]] where [[IN_ARG]] : Foo, [[OUT_ARG]] : Foo
public func foo<T: Foo>(_ x: T) -> some Foo {
  return x
}

public protocol AssocTypeInference {
  associatedtype Assoc: Foo

  func foo(_: Int) -> Assoc
}

public struct Bar<T>: AssocTypeInference {
  // CHECK-LABEL: @_opaqueReturnTypeDecl(
  // CHECK-SAME:    [[OPAQUE_DECL_FOR_BAR_ASSOC:.*]]) public func foo(_: Int) -> some Foo
  // CHECK-NEXT:  public __opaque_type [[OPAQUE_DECL_FOR_BAR_ASSOC]] -> <[[ARG:.*]]> [[ARG]] where [[ARG]] : Foo
  public func foo(_: Int) -> some Foo {
    return 20721
  }

  // CHECK-LABEL: @_opaqueReturnTypeDecl(
  public func foo(_: String) -> some Foo {
    return 219
  }

  // CHECK-LABEL: @_opaqueReturnTypeDecl(
  // CHECK-SAME:    [[OPAQUE_DECL:.*]]) public func foo<U>(_ x: U) -> some Foo where U : Foo
  // CHECK-NEXT:  public __opaque_type [[OPAQUE_DECL]]<[[IN:.*]]> -> <[[OUT:.*]]> [[OUT]] where [[IN]] : Foo, [[OUT]] : Foo
  public func foo<U: Foo>(_ x: U) -> some Foo {
    return x
  }

  public struct Bas: AssocTypeInference {
    // CHECK-LABEL: @_opaqueReturnTypeDecl(
    // CHECK-SAME:    [[OPAQUE_DECL_FOR_BAS_ASSOC:.*]]) public func foo(_: Int) -> some Foo
    // CHECK-NEXT:  public __opaque_type [[OPAQUE_DECL_FOR_BAS_ASSOC]] -> <[[ARG:.*]]> [[ARG]] where [[ARG]] : Foo
    public func foo(_: Int) -> some Foo {
      return 20721
    }

    // CHECK-LABEL: @_opaqueReturnTypeDecl(
    public func foo(_: String) -> some Foo {
      return 219
    }

    // CHECK-LABEL: @_opaqueReturnTypeDecl(
    // CHECK-SAME:    [[OPAQUE_DECL:.*]]) public func foo<U>(_ x: U) -> some Foo where U : Foo
    // CHECK-NEXT:  public __opaque_type [[OPAQUE_DECL]]<[[IN:.*]]> -> <[[OUT:.*]]> [[OUT]] where [[IN]] : Foo, [[OUT]] : Foo
    public func foo<U: Foo>(_ x: U) -> some Foo {
      return x
    }

    // CHECK-LABEL: public typealias Assoc =
    // CHECK-SAME:    main.Bar<T>.Bas.[[OPAQUE_DECL_FOR_BAS_ASSOC]]
  }

  public struct Bass<U: Foo>: AssocTypeInference {
    // CHECK-LABEL: @_opaqueReturnTypeDecl(
    // CHECK-SAME:    [[OPAQUE_DECL_FOR_BASS_ASSOC:.*]]) public func foo(_: Int) -> some Foo
    // CHECK-NEXT:  public __opaque_type [[OPAQUE_DECL_FOR_BASS_ASSOC]] -> <[[ARG:.*]]> [[ARG]] where [[ARG]] : Foo
    public func foo(_: Int) -> some Foo {
      return 20721
    }

    // CHECK-LABEL: @_opaqueReturnTypeDecl(
    public func foo(_: String) -> some Foo {
      return 219
    }

    // CHECK-LABEL: @_opaqueReturnTypeDecl(
    // CHECK-SAME:    [[OPAQUE_DECL:.*]]) public func foo(_ x: U) -> some Foo
    // CHECK-NEXT:  public __opaque_type [[OPAQUE_DECL]] -> <[[ARG:.*]]> [[ARG]] where [[ARG]] : Foo
    public func foo(_ x: U) -> some Foo {
      return x
    }

    // CHECK-LABEL: @_opaqueReturnTypeDecl(
    // CHECK-SAME:    [[OPAQUE_DECL:.*]]) public func foo<V>(_ x: V) -> some Foo where V : Foo
    // CHECK-NEXT:  public __opaque_type [[OPAQUE_DECL]]<[[IN:.*]]> -> <[[OUT:.*]]> [[OUT]] where [[IN]] : Foo, [[OUT]] : Foo
    public func foo<V: Foo>(_ x: V) -> some Foo {
      return x
    }

    // CHECK-LABEL: public typealias Assoc =
    // CHECK-SAME:    main.Bar<T>.Bass<U>.[[OPAQUE_DECL_FOR_BASS_ASSOC]]
  }

  // CHECK-LABEL: public typealias Assoc =
  // CHECK-SAME:    main.Bar<T>.[[OPAQUE_DECL_FOR_BAR_ASSOC]]
}

public struct Zim: AssocTypeInference {
  // CHECK-LABEL: @_opaqueReturnTypeDecl(
  public func foo(_: Int) -> some Foo {
    return 20721
  }

  // CHECK-LABEL: @_opaqueReturnTypeDecl(
  public func foo(_: String) -> some Foo {
    return 219
  }

  // CHECK-LABEL: @_opaqueReturnTypeDecl(
  // CHECK-SAME:    [[OPAQUE_DECL:.*]]) public func foo<U>(_ x: U) -> some Foo where U : Foo
  // CHECK-NEXT:  public __opaque_type [[OPAQUE_DECL]]<[[IN:.*]]> -> <[[OUT:.*]]> [[OUT]] where [[IN]] : Foo, [[OUT]] : Foo
  public func foo<U: Foo>(_ x: U) -> some Foo {
    return x
  }

  public struct Zang: AssocTypeInference {
    // CHECK-LABEL: @_opaqueReturnTypeDecl(
    public func foo(_: Int) -> some Foo {
      return 20721
    }

    // CHECK-LABEL: @_opaqueReturnTypeDecl(
    public func foo(_: String) -> some Foo {
      return 219
    }

    // CHECK-LABEL: @_opaqueReturnTypeDecl(
    // CHECK-SAME:    [[OPAQUE_DECL:.*]]) public func foo<U>(_ x: U) -> some Foo where U : Foo
    // CHECK-NEXT:  public __opaque_type [[OPAQUE_DECL]]<[[IN:.*]]> -> <[[OUT:.*]]> [[OUT]] where [[IN]] : Foo, [[OUT]] : Foo
    public func foo<U: Foo>(_ x: U) -> some Foo {
      return x
    }
  }

  public struct Zung<U: Foo>: AssocTypeInference {
    // CHECK-LABEL: @_opaqueReturnTypeDecl(
    // CHECK-SAME:    [[OPAQUE_DECL_FOR_ZUNG_ASSOC:.*]]) public func foo(_: Int) -> some Foo
    // CHECK-NEXT:  public __opaque_type [[OPAQUE_DECL_FOR_ZUNG_ASSOC]] -> <[[ARG:.*]]> [[ARG]] where [[ARG]] : Foo
    public func foo(_: Int) -> some Foo {
      return 20721
    }

    // CHECK-LABEL: @_opaqueReturnTypeDecl(
    public func foo(_: String) -> some Foo {
      return 219
    }

    // CHECK-LABEL: @_opaqueReturnTypeDecl(
    public func foo(_ x: U) -> some Foo {
      return x
    }

    // CHECK-LABEL: @_opaqueReturnTypeDecl(
    // CHECK-SAME:    [[OPAQUE_DECL:.*]]) public func foo<V>(_ x: V) -> some Foo where V : Foo
    // CHECK-NEXT:  public __opaque_type [[OPAQUE_DECL]]<[[IN:.*]]> -> <[[OUT:.*]]> [[OUT]] where [[IN]] : Foo, [[OUT]] : Foo
    public func foo<V: Foo>(_ x: V) -> some Foo {
      return x
    }

    // CHECK-LABEL: public typealias Assoc =
    // CHECK-SAME:    main.Zim.Zung<U>.[[OPAQUE_DECL_FOR_ZUNG_ASSOC]]
  }
}
