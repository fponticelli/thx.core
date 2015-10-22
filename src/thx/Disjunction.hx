package thx;

import thx.Either;
import thx.Functions.*;
using thx.Functions;

/**
This abstract provides a right-biased functor and monad over the Either type.
**/
abstract Disjunction<A, B> (Either<A, B>) from Either<A, B> to Either<A, B> {
  public static function pure<E, A>(a: A): Disjunction<E, A>
    return Right(a);

  inline public function map<C>(f: B -> C): Disjunction<A, C> 
    return flatMap(function(b) { return Right(f(b)); });

  public function flatMap<C>(f: B -> Either<A, C>): Disjunction<A, C> 
    return switch this {
      case Left(a) : Left(a);
      case Right(b): f(b);
    };

  public function leftMap<C>(f: A -> C): Disjunction<C, B> 
    return switch this {
      case Left(a) : Left(f(a));
      case Right(b): Right(b);
    };
}
