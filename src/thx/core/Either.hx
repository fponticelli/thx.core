package thx.core;

/**
`Either` wraps one value of two possible types.
*/
enum Either<L, R> {
/**
Left contructors wrapping a value of type L
*/
  Left(value : L);
/**
Right contructors wrapping a value of type R
*/
  Right(value : R);
}