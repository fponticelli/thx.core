package thx;

import thx.Semigroup;

enum Ordering {
  LT; GT; EQ;
}

abstract Ord<A> (A -> A -> Ordering) from A -> A -> Ordering to A -> A -> Ordering {
  public function order(a0: A, a1: A): Ordering
    return this(a0, a1);

  public function contramap<B>(f: B -> A): Ord<B> 
    return function(b0, b1) { return this(f(b0), f(b1)); };
}
