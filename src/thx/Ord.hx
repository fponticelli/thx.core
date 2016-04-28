package thx;

import thx.Semigroup;
import thx.fp.Comparable;
import thx.fp.ComparableOrd;

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

class Orderings {
  public static var monoid(default, never): Monoid<Ordering> = {
    zero: EQ,
    append: function(o0: Ordering, o1: Ordering): Ordering return switch o0 {
      case LT: LT;
      case EQ: o1;
      case GT: GT;
    }
  };

  public static function negate(o: Ordering): Ordering return switch o {
    case LT: GT;
    case EQ: EQ;
    case GT: LT;
  };
}

@:callable
abstract Ord<A> (A -> A -> Ordering) from A -> A -> Ordering to A -> A -> Ordering {
  public function order(a0: A, a1: A): Ordering
    return this(a0, a1);

  public function max(a0: A, a1: A): A
    return switch this(a0, a1) {
      case LT | EQ: a1;
      case GT: a0;
    };

  public function min(a0: A, a1: A): A
    return switch this(a0, a1) {
      case LT | EQ: a0;
      case GT: a1;
    };

  public function equal(a0: A, a1: A): Bool
    return this(a0, a1) == EQ;

  public function contramap<B>(f: B -> A): Ord<B>
    return function(b0, b1) { return this(f(b0), f(b1)); };

  public function inverse(): Ord<A> 
    return function(a0: A, a1: A) { return this(a1, a0); };

  public function intComparison(a0: A, a1: A): Int
    return switch this(a0, a1) {
      case LT: -1;
      case EQ: 0;
      case GT: 1;
    };

  public static function fromIntComparison<A>(f : A -> A -> Int) : Ord<A>
    return function(a : A, b : A) { return Ordering.fromInt(f(a, b)); };

  public static function forComparable<T : Comparable<T>>(): Ord<T>
    return function(a: T, b: T) { return Ordering.fromInt(a.compareTo(b)); };

  public static function forComparableOrd<T : ComparableOrd<T>>(): Ord<T>
    return function(a: T, b: T) { return a.compareTo(b); };

}
