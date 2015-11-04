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
  public static function toLeftUnsafe<L, R>(either : Either<L, R>) : L {
    return switch either {
      case Left(v) : v;
      case Right(_) : null;
    };
  }

  /**
    Extracts the right value if Right, or null if Left.
  **/
  public static function toRightUnsafe<L, R>(either : Either<L, R>) : R {
    return switch either {
      case Left(_) : null;
      case Right(v) : v;
    };
  }

  /**
    Maps an Either<L, RIn> to and Either<L, ROut>.
  **/
  public static function flatMap<L, RIn, ROut>(either : Either<L, RIn>, f : RIn -> Either<L, ROut>) : Either<L, ROut> {
    return switch either {
      case Left(v) : Left(v);
      case Right(v) : f(v);
    };
  }
}
