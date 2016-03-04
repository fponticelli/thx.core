package thx;

import thx.Semigroup;

typedef MonoidImpl<A> = {
  zero: A,
  append: A -> A -> A
};

abstract Monoid<A> (MonoidImpl<A>) from MonoidImpl<A> {
  public var semigroup(get, never): Semigroup<A>;
  function get_semigroup(): Semigroup<A> return this.append;

  public var zero(get, never): A;
  function get_zero() return this.zero;

  public function append(a0: A, a1: A): A
    return this.append(a0, a1);
}
