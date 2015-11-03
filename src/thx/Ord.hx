package thx;

import thx.Semigroup;

abstract Ordering(OrderingImpl) from OrderingImpl to OrderingImpl {
  @:from public static function fromInt(value : Int) : Ordering
    return value < 0 ? LT : (value > 0 ? GT : EQ);

  public static function fromFloat(value : Float) : Ordering
    return value < 0 ? LT : (value > 0 ? GT : EQ);

  @:to public function toInt() : Int
    return switch this {
      case LT: -1;
      case GT: 1;
      case EQ: 0;
    };
}

enum OrderingImpl {
  LT; GT; EQ;
}

@:callable
abstract Ord<A> (A -> A -> Ordering) from A -> A -> Ordering to A -> A -> Ordering {
  @:from public static function fromIntComparison<A>(f : A -> A -> Int) : Ord<A>
    return function(a : A, b : A) : Ordering return f(a, b);

  inline public function order(a0: A, a1: A): Ordering
    return this(a0, a1);

  public function contramap<B>(f: B -> A): Ord<B>
    return function(b0, b1) { return this(f(b0), f(b1)); };
}
