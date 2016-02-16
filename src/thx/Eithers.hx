package thx;

import haxe.ds.Option;

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

  public static function toVNel<E, T>(either: Either<E, T>): Validation.VNel<E, T>
    return switch either {
      case Left(e): Validation.failureNel(e);
      case Right(v): Validation.successNel(v);
    };

  public static function cata<L, R, A>(either: Either<L, R>, l: L -> A, r: R -> A): A
    return switch either {
      case Left(l0):  l(l0);
      case Right(r0): r(r0);
    };

}
