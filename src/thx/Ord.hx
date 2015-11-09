package thx;

import thx.Semigroup;

abstract Ordering(OrderingImpl) from OrderingImpl to OrderingImpl {
  public static function fromInt(value : Int) : Ordering
    return value < 0 ? LT : (value > 0 ? GT : EQ);

  public static function fromFloat(value : Float) : Ordering
    return value < 0 ? LT : (value > 0 ? GT : EQ);

  public function toInt() : Int
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
  public static function fromIntComparison<A>(f : A -> A -> Int) : Ord<A>
    return function(a : A, b : A) : Ordering return Ordering.fromInt(f(a, b));

  inline public function order(a0: A, a1: A): Ordering
    return this(a0, a1);

  public function contramap<B>(f: B -> A): Ord<B>
    return function(b0, b1) { return this(f(b0), f(b1)); };

  public function inverse(): Ord<A> return function(a0: A, a1: A) { return this(a1, a0); };

  public static function fromCompare<A>(f: A -> A -> Int): Ord<A>
    return function(a0: A, a1: A) {
      var i = f(a0, a1);
      return if (i < 0) LT else if (i == 0) EQ else GT;
    };
}
