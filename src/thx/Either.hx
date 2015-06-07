package thx;

#if (haxe_version >= 3.2)
typedef Either = haxe.ds.Either;
#else
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
#end