package thx.fp;

import thx.Monoid;
using thx.Arrays;
using thx.Functions;

abstract List<A>(ListImpl<A>) from ListImpl<A> to ListImpl<A> {
  inline static public function empty<A>() : List<A>
    return Nil;

  inline static public function bin<A>(x : A, xs : List<A>) : List<A>
    return Cons(x, xs);

  inline static public function singleton<A>(x : A) : List<A>
    return Cons(x, Nil);

  @:from
  inline static public function fromArray<A>(arr : Array<A>) : List<A>
    return arr.reduceRight(
      function(memo,next){
        return switch(memo){
          case Nil        : Cons(next,Nil);
          case Cons(x,xs) : Cons(next,Cons(x,xs));
        }
      },
      empty()
    );

  public function foldLeft<B>(b : B, f : B -> A -> B) : B
    return switch this {
      case Nil: b;
      case Cons(x, xs): xs.foldLeft(f(b, x), f);
    }

  public function foldMap<B>(f: A -> B, m: Monoid<B>): B
    return map(f).foldLeft(m.zero, m.append);

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
  public function head():Null<A>{
    return switch(this){
      case Cons(x,xs) : x;
      default         : null;
    }
  }
  public function tail():List<A>{
    return switch(this){
      case Cons(x,xs) : xs;
      default         : empty();
    }
  }
  public function last():Null<A>{
    var crs = this;
    var val = null;
    while(true){
      switch crs {
        case Cons(x,xs):
          val = x;
          crs = xs;
        default: break;
      }
    }
    return val;
  }
  public function isDefined():Bool{
    return switch(this){
      case Nil    : false;
      default     : true;
    }
  }
  public function map<B>(f : A -> B) : List<B>
    return switch this {
      case Nil: Nil;
      case Cons(x, xs): Cons(f(x), xs.map(f));
    };

  public function zipAp<B>(other: List<A -> B>): List<B>
    return switch this {
      case Nil: Nil;
      case Cons(x, xs):
        switch other {
          case Nil: Nil;
          case Cons(y, ys): Cons(y(x), xs.zipAp(ys));
        };
    };
  public function iterator():Iterator<A>{
    var cursor : Null<List<A>> = this;
    return {
      next : function(){
        var value = null;
        switch(cursor){
          case Cons(x,xs) :
            value  = x;
            cursor = xs;
          default : cursor = List.empty();
        }
        return value;
      },
      hasNext : function(){
        return switch cursor {
          case Nil : false;
          default : true;
        }
      }
    }
  }
  /**
   * Zip two arrays by applying the provided function to the aligned members.
   */
  public static function zip2Ap<A, B, C>(f: A -> B -> C, ax: List<A>, bx: List<B>): List<C>
    return bx.zipAp(ax.map(Functions2.curry(f)));

  /**
   * Zip three arrays by applying the provided function to the aligned members.
   */
  public static function zip3Ap<A, B, C, D>(f: A -> B -> C -> D, ax: List<A>, bx: List<B>, cx: List<C>): List<D>
    return cx.zipAp(zip2Ap(Functions3.curry(f), ax, bx));

  /**
   * Zip four arrays by applying the provided function to the aligned members.
   */
  public static function zip4Ap<A, B, C, D, E>(f: A -> B -> C -> D -> E, ax: List<A>, bx: List<B>, cx: List<C>, dx: List<D>): List<E>
    return dx.zipAp(zip3Ap(Functions4.curry(f), ax, bx, cx));

  /**
   * Zip five arrays by applying the provided function to the aligned members.
   */
  public static function zip5Ap<A, B, C, D, E, F>(f: A -> B -> C -> D -> E -> F, ax: List<A>, bx: List<B>, cx: List<C>, dx: List<D>, ex: List<E>): List<F>
    return ex.zipAp(zip4Ap(Functions5.curry(f), ax, bx, cx, dx));

  public function toStringWithShow(show : A -> String) : String
    return thx.fp.Lists.StringList.toString(map(show));
}

enum ListImpl<A> {
  Nil;
  Cons(x : A, xs : List<A>);
}
