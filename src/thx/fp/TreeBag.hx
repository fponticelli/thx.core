package thx.fp;

using thx.Arrays;
import thx.Functions;
import thx.Monoid;
import thx.fp.List;

/**
 * A simple unordered immutable data structure that supports O(1) append and
 * concatenation.
 */
abstract TreeBag<A> (TreeBagImpl<A>) from TreeBagImpl<A> to TreeBagImpl<A> {
  inline public static function empty<A>() : TreeBag<A> 
    return Empty;

  inline public static function singleton<A>(a: A): TreeBag<A>
    return Cons(a, Empty);

  inline public static function cons<A>(x : A, xs: TreeBag<A>) : TreeBag<A> 
    return Cons(x, xs);

  inline public static function fromArray<A>(xs: Array<A>): TreeBag<A> 
    return xs.reduce(function(acc, x) { return cons(x, acc); }, Empty);

  inline public static function flatten<A>(xs: TreeBag<TreeBag<A>>): TreeBag<A>
    return xs.flatMap(Functions.identity);

  inline public function prepend(x : A) : TreeBag<A> 
    return Cons(x, this);

  @:op(A+B) 
  inline public function append(other: TreeBag<A>): TreeBag<A> {
    return switch [this, other] {
      case [Empty, Empty]: Empty;
      case [Empty, _]: other;
      case [_, Empty]: this;
      case [Cons(x, Empty), _]: Cons(x, other);
      case _: Branch(this, other);
    }
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
      case Cons(x, xs): f(x) + xs.flatMap(f);
      case Branch(l, r): l.flatMap(f) + r.flatMap(f);
    }
  }

  public function foldLeft<A, B>(b: B, f : B -> A -> B) : B {
    var acc = b;
    var nodes = List.singleton(this);
    while(true) {
      switch nodes {
        case ListImpl.Nil: return acc;
        case ListImpl.Cons(y, ys):
          switch y {
            case Empty: 
              nodes = ys;
            case Cons(x, xs): 
              acc = f(acc, x);
              nodes = ys.prepend(xs);
            case Branch(l, r): 
              nodes = ys.prepend(r).prepend(l);
          }
      }
    }
  }

  public function length(): Int
    return foldLeft(0, function(c, a) return c + 1);

  public function toArray(): Array<A> {
    return foldLeft([], function(b: Array<A>, a: A) { b.push(a); return b; });
  }

  public static function monoid<A>(): Monoid<TreeBag<A>>
    return {
      zero: TreeBag.empty(),
      append: function(l: TreeBag<A>, r: TreeBag<A>) return l.append(r)
    };
}

enum TreeBagImpl<A> {
  Empty;
  Cons(x : A, xs : TreeBag<A>);
  Branch(left : TreeBag<A>, right : TreeBag<A>);
}
