package thx;

import thx.Semigroup;

typedef MonoidStruct<A> = {
  zero: A,
  append: A -> A -> A
};

abstract Monoid<A> (MonoidStruct<A>) from MonoidStruct<A> {
  public var semigroup(get, never): Semigroup<A>;
  function get_semigroup(): Semigroup<A> return this.append;

  public var zero(get, never): A;
  function get_zero() return this.zero;

  inline public function append(a0: A, a1: A): A
    return this.append(a0, a1);
}
