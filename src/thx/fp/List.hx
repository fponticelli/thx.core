package thx.fp;

using thx.Arrays;
using thx.Functions;

abstract List<A>(ListImpl<A>) from ListImpl<A> to ListImpl<A> {
  inline static public function empty<A>() : List<A>
    return Empty;

  inline static public function cons<A>(x : A, xs : List<A>) : List<A>
    return Cons(x, xs);

  @:from
  inline static public function fromArray<A>(arr : Array<A>) : List<A>
    return arr.reduceRight.fn(cons(_1, _0), empty());

  public function foldLeft<B>(b : B, f : B -> A -> B) : B
    return switch this {
      case Empty: b;
      case Cons(x, xs): xs.foldLeft(f(b, x), f);
    }

  inline public function prepend(x : A) : List<A>
    return Cons(x, this);

  // @:op(A+B) inline public function append(other: List<A>): List<A>
  //   return Branch(this, other);

  @:to
  inline public function toArray() : Array<A>
    return foldLeft([], function(acc, a) {
      acc.push(a);
      return acc;
    });

  public function intercalate(a: A): List<A> {
    function go(ls) return switch ls {
      case Cons(x, xs):
        Cons(a, Cons(x, go(xs)));
      case Empty:
        Empty;
    };

    return switch this {
      case Empty: Empty;
      case Cons(x, xs): Cons(x, Cons(a, go(xs)));
    };
  }

  // public function toString()
  //   return "[" + intercalate(",") + "]"

/*
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
*/
}

enum ListImpl<A> {
  Empty;
  Cons(x : A, xs : List<A>);
}
