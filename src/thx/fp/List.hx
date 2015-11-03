package thx.fp;

using thx.Arrays;
using thx.Functions;
import thx.Functions.*;

abstract List<A>(ListImpl<A>) from ListImpl<A> to ListImpl<A> {
  inline static public function empty<A>() : List<A>
    return Nil;

  inline static public function cons<A>(x : A, xs : List<A>) : List<A>
    return Cons(x, xs);

  inline static public function create<A>(x : A) : List<A>
    return Cons(x, Nil);

  @:from
  inline static public function fromArray<A>(arr : Array<A>) : List<A>
    return arr.reduceRight.fn(cons(_1, _0), empty());

  public function foldLeft<B>(b : B, f : B -> A -> B) : B
    return switch this {
    case Nil: b;
      case Cons(x, xs): xs.foldLeft(f(b, x), f);
    }

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
    return foldLeft(Nil, fn(Cons(f(_1), _0)));

  inline public static function stringToStringImpl(l : List<String>) : String
    return "[" + l.intersperse(",").foldLeft("", fn(_1 + _0)) + "]";

  public function toStringWithShow(show : A -> String) : String
    return List.stringToStringImpl(map(show));

  @:to @:impl
  public static function stringToString(l : List<String>) : String
    return stringToStringImpl(l);

  @:to @:impl
  public static function intToString(l : List<Int>) : String
    return l.toStringWithShow(Ints.toString.bind(_, 10));

  @:to @:impl
  public static function floatToString(l : List<Int>) : String
    return l.toStringWithShow(Floats.toString);
}

enum ListImpl<A> {
  Nil;
  Cons(x : A, xs : List<A>);
}
