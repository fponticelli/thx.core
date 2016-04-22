package thx;

import haxe.ds.Option;

/**
`Result` is a wrapper type (abstract) around the `Either` type to semantically represent the state of an operation.
*/
abstract Result<TSuccess, TFailure>(Either<TFailure, TSuccess>) from Either<TFailure, TSuccess> to Either<TFailure, TSuccess> {
  inline public static function success<TSuccess, TFailure>(value : TSuccess) : Result<TSuccess, TFailure>
    return Either.Right(value);

  inline public static function failure<TSuccess, TFailure>(error : TFailure) : Result<TSuccess, TFailure>
    return Either.Left(error);
/**
It is true if `Result` wraps a value.
*/
  public var isSuccess(get, never) : Bool;

/**
It is true if `Result` wraps an error.
*/
  public var isFailure(get, never) : Bool;

/**
Converts `Result<TSuccess, TFailure>` into `Option<TSuccess>`. The result is `Some(value)` if `Result` contained a value.
It is `None` if it contains an error.
*/
  @:to public function optionValue() : Option<TSuccess>
    return switch this {
      case Right(v): Some(v);
      case _: None;
    };

/**
Converts `Result<TSuccess, TFailure>` into `Option<TFailure>`. The result is `Some(error)` if `Result` contained an error.
It is `None` if it contains a value.
*/
  @:to public function optionError() : Option<TFailure>
    return switch this {
      case Left(v): Some(v);
      case _: None;
    };

/**
Converts `Result` into a nullable value of type TSuccess.
*/
  @:to public function value() : Null<TSuccess>
    return switch this {
      case Right(v): v;
      case _: null;
    };

/**
Converts `Result` into a nullable value of type TFailure.
*/
  @:to public function error() : Null<TFailure>
    return switch this {
      case Left(v): v;
      case _: null;
    };

  function get_isSuccess()
    return switch this {
      case Right(_): true;
      case _: false;
    };

  function get_isFailure()
    return switch this {
      case Left(_): true;
      case _: false;
    };
}
