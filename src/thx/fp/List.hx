package thx.fp;

using thx.Arrays;
using thx.Functions;
import thx.Functions.*;

abstract List<A>(ListImpl<A>) from ListImpl<A> to ListImpl<A> {
  inline static public function empty<A>() : List<A>
    return Nil;

  inline static public function bin<A>(x : A, xs : List<A>) : List<A>
    return Cons(x, xs);

  inline static public function singleton<A>(x : A) : List<A>
    return Cons(x, Nil);

  @:from
  inline static public function fromArray<A>(arr : Array<A>) : List<A>
    return arr.reduceRight.fn(bin(_1, _0), empty());

  public function foldLeft<B>(b : B, f : B -> A -> B) : B
    return switch this {
      case Nil: b;
      case Cons(x, xs): xs.foldLeft(f(b, x), f);
    }

  public function flatMap<B>(f : A -> List<B>) : List<B>
    return switch this {
      case Nil: Nil;
      case Cons(x, xs): f(x).concat(xs.flatMap(f));
    };

  public function concat(that : List<A>) : List<A>
    return switch [this, that] {
      case [Nil, Nil]: Nil;
      case [Nil, l]
         | [l, Nil]: l;
      case [Cons(x, Nil), _]:
        Cons(x, that);
      case [Cons(x, xs), _]:
        Cons(x, xs.concat(that));
    };

  inline public function prepend(x : A) : List<A>
    return Cons(x, this);

  @:to
  inline public function toArray() : Array<A>
    return foldLeft([], function(acc, a) {
      acc.push(a);
      return acc;
    });

  public function intersperse(a: A): List<A> {
    function go(ls) return switch ls {
      case Cons(x, xs):
        Cons(a, Cons(x, go(xs)));
      case Nil:
        Nil;
    };

    return switch this {
      case Nil: Nil;
      case Cons(x, xs): Cons(x, go(xs));
    };
  }

  public function map<B>(f : A -> B) : List<B>
    return switch this {
      case Nil: Nil;
      case Cons(x, xs): Cons(f(x), xs.map(f));
    };

  public function toStringWithShow(show : A -> String) : String
    return StringList.toString(map(show));
}

class StringList {
  inline public static function toString(l : List<String>) : String
    return "[" + l.intersperse(",").foldLeft("", fn(_0 + _1)) + "]";
}

class FloatList {
  inline public static function toString(l : List<Float>) : String
    return l.toStringWithShow(Floats.toString);
}

class IntList {
  inline public static function toString(l : List<Int>) : String
    return l.toStringWithShow(Ints.toString.bind(_, 10));
}

class ObjectList {
  inline public static function toString(l : List<{ toString : Void -> String }>) : String
    return l.toStringWithShow(function(o) return o.toString());
}

enum ListImpl<A> {
  Nil;
  Cons(x : A, xs : List<A>);
}
