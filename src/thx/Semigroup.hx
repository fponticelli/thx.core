package thx;

// Semigroups instances should obey the associative law.
abstract Semigroup<A> (A -> A -> A) from A -> A -> A to A -> A -> A {
  public var append(get, never): A -> A -> A; 
  private function get_append() return this;
}

