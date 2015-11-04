package thx.fp;

import thx.Ord;

typedef ComparableOrd<T> = {
  public function compareTo(that : T) : Ordering;
}
