package thx;

import haxe.ds.Option;
using thx.Functions;
using thx.Arrays;

abstract Nel<A> (NonEmptyList<A>) from NonEmptyList<A> to NonEmptyList<A> {
  public static function nel<A>(hd: A, tl: Array<A>): Nel<A> {
    return switch fromArray(tl) {
      case Some(nel): cons(hd, nel);
      case None: pure(hd);
    }
  }

  public static function pure<A>(a: A): Nel<A>
    return Single(a);

  public static function cons<A>(a: A, nl: NonEmptyList<A>): Nel<A>
    return ConsNel(a, nl);

  public static function fromArray<A>(arr: ReadonlyArray<A>): Option<Nel<A>> 
    return 
      if (arr.length == 0) None else {
        var res: NonEmptyList<A> = Single(arr[arr.length - 1]);
        for (i in Ints.rangeIter(arr.length - 2, -1, -1)) {
          res = ConsNel(arr[i], res);
        }

        Some(res);
      };

  public function map<B>(f: A -> B): Nel<B>
    return flatMap(pure.compose(f));

  public function flatMap<B>(f: A -> NonEmptyList<B>): Nel<B> 
    return switch this {
      case Single(x): f(x);
      case ConsNel(x, xs): (f(x): Nel<B>) + xs.flatMap(f);
    };

  public function fold(f: A -> A -> A): A
    return switch this {
      case Single(x): x;
      case ConsNel(x, xs): f(x, xs.fold(f));
    };

  @:op(N+N0) 
  public function append(nel: NonEmptyList<A>): Nel<A> 
    // TODO: Implement imperatively for stack safety.
    return switch this {
      case Single(x): ConsNel(x, nel);
      case ConsNel(x, xs): ConsNel(x, xs.append(nel));
    };

  public function toArray(): Array<A> {
    function go(acc: Array<A>, xs: NonEmptyList<A>) {
      return switch xs {
        case Single(x): acc.append(x);
        case ConsNel(x, xs): go(acc.append(x), xs);
      }
    }

    return go([], this).reversed();
  }

  public static function semigroup<A>(): Semigroup<Nel<A>> {
    return function(nl: NonEmptyList<A>, nr: NonEmptyList<A>) { return (nl: Nel<A>).append((nr: Nel<A>)); };
  }
}

enum NonEmptyList<A> {
  Single(x: A);
  ConsNel(x: A, xs: Nel<A>);
}

