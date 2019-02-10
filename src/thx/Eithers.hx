package thx;

import haxe.ds.Option;
using thx.Functions;

/**
  Extension methods for the `thx.Either` type.
**/
class Eithers {
  /**
    Indicates if the either has a Left value
  **/
  public static function isLeft<L, R>(either : Either<L, R>) : Bool {
    return switch either {
      case Left(_) : true;
      case Right(_): false;
    };
  }

  /**
    Indicates if the either has a Right value
  **/
  public static function isRight<L, R>(either : Either<L, R>) : Bool {
    return switch either {
      case Left(_) : false;
      case Right(_): true;
    };
  }

  /**
    Converts the Either<L, R> to an Option<L> containing the Left value if Left, or None if Right.
  **/
  public static function toLeft<L, R>(either : Either<L, R>) : Option<L> {
    return switch either {
      case Left(v) : Some(v);
      case Right(_) : None;
    };
  }

  /**
    Converts the Either<L, R> to an Option<R> containing the Right value if Right, or None if Left.
  **/
  public static function toRight<L, R>(either : Either<L, R>) : Option<R> {
    return switch either {
      case Left(_) : None;
      case Right(v) : Some(v);
    };
  }

  /**
    Extracts the left value if Left, or null if Right.
  **/
  public static function toLeftUnsafe<L, R>(either : Either<L, R>) : Null<L> {
    return switch either {
      case Left(v) : v;
      case Right(_) : null;
    };
  }

  /**
    Extracts the right value if Right, or null if Left.
  **/
  public static function toRightUnsafe<L, R>(either : Either<L, R>) : Null<R> {
    return switch either {
      case Left(_) : null;
      case Right(v) : v;
    };
  }

  public static function map<L, RIn, ROut>(either: Either<L, RIn>, f: RIn -> ROut): Either<L, ROut>
    return switch either {
      case Left(v) : Left(v);
      case Right(v) : Right(f(v));
    };

  /**
   * `ap` transforms a value contained in `Either<E, RIn>` to `Either<E, ROut>` using a `callback`
   * wrapped in the right side of another Either.
   */
  public static function ap<L, RIn, ROut>(either : Either<L, RIn>, fa: Either<L, RIn -> ROut>): Either<L, ROut>
    return switch either {
      case Left(l): Left(l);
      case Right(v): map(fa, function(f) return f(v));
    };

  /**
    Maps an Either<L, RIn> to and Either<L, ROut>.
  **/
  public static function flatMap<L, RIn, ROut>(either : Either<L, RIn>, f : RIn -> Either<L, ROut>) : Either<L, ROut> {
    return switch either {
      case Left(v) : Left(v);
      case Right(v) : f(v);
    };
  }

  public static function leftMap<LIn, LOut, R>(either: Either<LIn, R>, f: LIn -> LOut): Either<LOut, R>
    return switch either {
      case Left(v) : Left(f(v));
      case Right(v): Right(v);
    };

  public static function orThrow<L, R>(either: Either<L, R>, message: String): R
    return switch either {
      case Left(v) : throw new thx.Error('$message: $v');
      case Right(v): v;
    };

  public static function toValidation<E, T>(either: Either<E, T>): Validation<E, T>
    return either;

  public static function toVNel<E, T>(either: Either<E, T>): Validation.VNel<E, T>
    return leftMap(either, Nel.pure);

  public static function cata<L, R, A>(either: Either<L, R>, l: L -> A, r: R -> A): A
    return switch either {
      case Left(l0):  l(l0);
      case Right(r0): r(r0);
    };

  public static function bimap<L, R, A, B>(either: Either<L, R>, l: L -> A, r: R -> B): Either<A, B> {
    return switch either {
      case Left(l0):  Left(l(l0));
      case Right(r0): Right(r(r0));
    }
  }

  public static function foldLeft<L, R, A>(either: Either<L, R>, a: A, f: A -> R -> A): A
    return switch either {
      case Left(l0):  a;
      case Right(r0): f(a, r0);
    };

  /**
   * Fold by mapping the contained value into some monoidal type and reducing with that monoid.
   */
  public static function foldMap<L, R, A>(either: Either<L, R>, f: R -> A, m: Monoid<A>): A {
    return foldLeft(map(either, f), m.zero, m.append);
  }

  public static function getOrElse<L, R>(e0: Either<L, R>, v: R) : R {
    return switch e0 {
      case Left(_) : v;
      case Right(v) : v;
    };
  }

  public static function getOrElseF<L, R>(e0: Either<L, R>, f : Void -> R) : R {
    return switch e0 {
      case Left(_) : f();
      case Right(v) : v;
    };
  }

  public static function orElse<L, R>(e0: Either<L, R>, e1: Either<L, R>): Either<L, R> {
    return switch e0 {
      case Left(e): e1;
      case r: r;
    };
  }

  public static function orElseF<L, R>(e0: Either<L, R>, f: Void -> Either<L, R>): Either<L, R> {
    return switch e0 {
      case Left(e): f();
      case r: r;
    };
  }

  public static function each<L, R>(either: Either<L, R>, f: R -> Void): Void {
    return switch either {
      case Left(l): null;
      case Right(r): f(r);
    };
  }

  public static function eachLeft<L, R>(either: Either<L, R>, f: L -> Void): Void {
    return switch either {
      case Left(l): f(l);
      case Right(r): null;
    };
  }

  public static function ensure<L, R>(either: Either<L, R>, p: R -> Bool, error: L): Either<L, R> {
    return switch either {
      case Right(a): if (p(a)) either else Left(error);
      case _: either;
    };
  }

  public static function exists<L, R>(either: Either<L, R>, p: R -> Bool): Bool {
    return switch either {
      case Right(a): p(a);
      case _: false;
    }
  }

  public static function forall<L, R>(either: Either<L, R>, p: R -> Bool): Bool {
    return switch either {
      case Right(a): p(a);
      case _: true;
    }
  }
}

// Kleisli arrow specialized to Either
abstract EitherK<A, L, R>(A -> Either<L, R>) from A -> Either<L, R> to A -> Either<L, R> {
  public function apply(a: A) return this(a);

  public function compose<A0>(f: EitherK<A0, L, A>): EitherK<A0, L, R> {
    return function(a0: A0) return Eithers.flatMap(f.apply(a0), this);
  }

  public function andThen<R0>(f: EitherK<R, L, R0>): EitherK<A, L, R0> {
    return function(a: A) return Eithers.flatMap(this(a), f.apply);
  }

  public static function pure<A, L, R>(r: R): EitherK<A, L, R> {
    return function(a: A) return Right(r);
  }

  public function map<R0>(f: R -> R0): EitherK<A, L, R0> {
    return flatMap(pure.compose(f));
  }

  public function ap<R0>(e: EitherK<A, L, R -> R0>): EitherK<A, L, R0> {
    return flatMap(function(r: R) return e.map(function(f: R -> R0) return f(r)));
  }

  public function flatMap<R0>(f: R -> EitherK<A, L, R0>): EitherK<A, L, R0> {
    return function(a: A) return Eithers.flatMap(this(a), function(r: R) return f(r).apply(a));
  }

  public static function monoid<L, R>(): Monoid<EitherK<R, L, R>> {
    return {
      zero: (function(r: R) return Right(r): EitherK<R, L, R>),
      append: function(f0: EitherK<R, L, R>, f1: EitherK<R, L, R>): EitherK<R, L, R> {
        return function(r: R) return Eithers.flatMap(f0.apply(r), f1.apply);
      }
    };
  }
}
