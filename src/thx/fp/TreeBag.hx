package thx.fp;

using thx.Arrays;
import thx.Functions;

/**
 * A simple unordered immutable data structure that supports O(1) append and
 * concatenation.
 */
abstract TreeBag<A> (TreeBagImpl<A>) from TreeBagImpl<A> to TreeBagImpl<A> {
  inline public static function empty<A>() : TreeBag<A> {
    return Empty;
  }

  inline public static function cons<A>(x : A, xs: TreeBag<A>) : TreeBag<A> {
    return Cons(x, xs);
  }

  inline public static function fromArray<A>(xs: Array<A>): TreeBag<A> {
    return xs.reduce(function(acc, x) { return cons(x, acc); }, Empty);
  }

  inline public static function flatten<A>(xs: TreeBag<TreeBag<A>>): TreeBag<A>
    return xs.flatMap(Functions.identity);

  inline public function prepend(x : A) : TreeBag<A> {
    return Cons(x, this);
  }

  @:op(A+B) inline public function append(other: TreeBag<A>): TreeBag<A> {
    return Branch(this, other);
  }

  public function prependAll(xs: Array<A>): TreeBag<A> {
    return xs.reduce(function(acc, x) { return cons(x, acc); }, this);
  }

  public function map<A, B>(f : A -> B) : TreeBag<B> {
    return switch this {
      case Empty: Empty;
      case Cons(x, xs): Cons(f(x), xs.map(f));
      case Branch(l, r): Branch(l.map(f), r.map(f));
    }
  }

  public function flatMap<A, B>(f : A -> TreeBag<B>) : TreeBag<B> {
    return switch this {
      case Empty: Empty;
      case Cons(x, xs): Branch(f(x), xs.flatMap(f));
      case Branch(l, r): Branch(l.flatMap(f), r.flatMap(f));
    }
  }

  public function foldLeft<A, B>(b: B, f : B -> A -> B) : B {
    return switch this {
      case Empty: b;
      case Cons(x, xs): xs.foldLeft(f(b, x), f);
      case Branch(l, r): r.foldLeft(l.foldLeft(b, f), f);
    }
  }

  public function toArray(): Array<A> {
    return foldLeft([], function(b: Array<A>, a: A) { b.push(a); return b; });
  }
}

enum TreeBagImpl<A> {
  Empty;
  Cons(x : A, xs : TreeBag<A>);
  Branch(left : TreeBag<A>, right : TreeBag<A>);
}
