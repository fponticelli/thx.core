package thx;

import haxe.ds.Option;
using thx.Functions;
using thx.Arrays;

/**
Abstract around `NonEmptyList<A>`, which is similar to a Cons-style list, but must contain
at least one element (cannot be empty).
**/
abstract Nel<A> (NonEmptyList<A>) from NonEmptyList<A> to NonEmptyList<A> {
  /**
  Constructs a `Nel<A>` from a head element and tail `Array<A>`
  **/
  public static function nel<A>(hd: A, tl: Array<A>): Nel<A> {
    return switch fromArray(tl) {
      case Some(nel): cons(hd, nel);
      case None: pure(hd);
    }
  }

/**
Constructs a `Nel<A>` from a head element
**/
  public static function pure<A>(a: A): Nel<A>
    return Single(a);

/**
Constructs a `Nel<A>` from a head element and tail `Nel<A>`
**/
  public static function cons<A>(a: A, nl: Nel<A>): Nel<A>
    return ConsNel(a, nl);

/**
Attempts to construct a `Nel<A>` from a possibly-empty `Array<A>`.  If the array
is empty, `None` is returned.
**/
  public static function fromArray<A>(arr: ReadonlyArray<A>): Option<Nel<A>>
    return
      if (arr.length == 0) None else {
        var res: Nel<A> = Single(arr[arr.length - 1]);
        for (i in Ints.rangeIter(arr.length - 2, -1, -1)) {
          res = ConsNel(arr[i], res);
        }
        Some(res);
      };

/**
Applies an `A -> B` function to each element in this `Nel<A>` to create a new `Nel<B>`
**/
  public function map<B>(f: A -> B): Nel<B>
    return flatMap(pure.compose(f));

/**
Applies an `A -> Nel<B>` function to each element in this `Nel<A>` and flattens the result to create a new `Nel<B>`
**/
  public function flatMap<B>(f: A -> Nel<B>): Nel<B>
    return switch this {
      case Single(x): f(x);
      case ConsNel(x, xs): (f(x): Nel<B>) + xs.flatMap(f);
    };

/**
Applies a reducing function to this `Nel<A>`
**/
  public function fold(f: A -> A -> A): A
    return switch this {
      case Single(x): x;
      case ConsNel(x, xs): f(x, xs.fold(f));
    };

/**
Appends another non-empty list to this `Nel<A>`.

Warning: this operation is `O(n)`
**/
  @:op(N+N0)
  public function append(nel: Nel<A>): Nel<A>
    // TODO: Implement imperatively for stack safety.
    return switch this {
      case Single(x): ConsNel(x, nel);
      case ConsNel(x, xs): ConsNel(x, xs.append(nel));
    };

  public function concat(xs: Array<A>): Nel<A> {
    return switch Nel.fromArray(xs) {
      case Some(other): (this: Nel<A>).append(other);
      case None: this;
    };
  }

/**
Gets the head item of this `Nel<A>`, which is guaranteed to exist
**/
  public function head() : A {
    return switch this {
      case Single(x) : x;
      case ConsNel(x, xs) : x;
    };
  }

/**
Gets the tail (all but the first element) of the `Nel<A>` as a possibly-empty `ReadonlyArray<A>`
**/
  public function tail() : ReadonlyArray<A> {
    return switch this {
      case Single(x) : [];
      case ConsNel(x, xs) : xs.toArray();
    };
  }

/**
Gets the initial elements (all but the last element) of the `Nel<A>` as a possibly-empty `ReadonlyArray<A>`

Warning: this operation is `O(n)`
**/
  public function init() : ReadonlyArray<A> {
    return switch this {
      case Single(x) : [];
      case ConsNel(x, xs) : [x].concat((xs : Nel<A>).init().unsafe());
    };
  }

/**
Gets the last item of the `Nel<A>`, which is guaranteed to exist.

Warning: this operation is `O(n)`
**/
  public function last() : A {
    return switch this {
      case Single(x) : x;
      case ConsNel(x, xs) : xs.last();
    };
  }

/**
Returns a new `Nel<A>` with the given item added at the end.

Does not modify this `Nel<A>`.

Warning: this operation is `O(n)`
**/
  public function push(a : A) : Nel<A> {
    return append(Single(a));
  }

/**
Returns the last item of the `Nel<A>` and a new `Nel<A>` with the last item removed.

Does not modify this `Nel<A>`.

Warning: this operation is `O(n)`
**/
  public function pop() : Tuple<A, ReadonlyArray<A>> {
    return new Tuple(last(), init());
  }

/**
Returns a new `Nel<A>` with the given item added at the front.

Does not modify this `Nel<A>`.
**/
  public function unshift(a : A) : Nel<A> {
    return ConsNel(a, this);
  }

/**
Returns the first item of the `Nel<A>` and a new `Nel<A>` with the first item removed.

Does not modify this `Nel<A>`.
**/
  public function shift() : Tuple<A, ReadonlyArray<A>> {
    return new Tuple(head(), tail());
  }

/**
Converts the `Nel<A>` to a `ReadonlyArray<A>`

Warning: this operation is `O(n)`
**/
  public function toArray(): ReadonlyArray<A> {
    function go(acc: Array<A>, xs: Nel<A>) {
      return switch xs {
        case Single(x): acc.append(x);
        case ConsNel(x, xs): go(acc.append(x), xs);
      }
    }
    return go([], this);
  }

  public function intersperse(a: A): Nel<A> {
    return switch this {
      case Single(x): Single(x);
      case ConsNel(x, xs): ConsNel(x, ConsNel(a, xs.intersperse(a)));
    }
  }

/**
Gets a `Semigroup` instance for `Nel<A>`, using the `append` method of `Nel<A>`.
**/
  public static function semigroup<A>(): Semigroup<Nel<A>> {
    return function(nl: Nel<A>, nr: Nel<A>) { return (nl: Nel<A>).append((nr: Nel<A>)); };
  }
}

enum NonEmptyList<A> {
  Single(x: A);
  ConsNel(x: A, xs: Nel<A>);
}
