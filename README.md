# thx.core

[![Build Status](https://travis-ci.org/fponticelli/thx.core.svg?branch=master)](https://travis-ci.org/fponticelli/thx.core)

[![Sauce Test Status](https://saucelabs.com/browser-matrix/thx-core.svg)](https://saucelabs.com/u/thx-core)

Generic multi-purpose library. `thx.core` aims to be the [lodash](http://lodash.com/) library for Haxe.

## data structures

`thx.core` provides a few data types to complet the standard library.

### [AnonymousMap](http://thx-lib.org/api/thx/core/AnonymousMap.html)

Wraps an anonymous object in `Map<String, T>` compatible structure.

```haxe
var map = new AnonymousMap({ name : "Franco" });

map.get("name"); // "Franco"
```

The intention of this class is not to encourage anonymous objects as data containers but to simplify the approach to untyped data like JSON results.

### [Either](http://thx-lib.org/api/thx/core/Either.html)

`Either` is a value container. It can contain values from two different types but only one per instance. It can be handy when you want to manage values that can be in one of two possible states. A classic example is a Result where the wrapped value can be either a success or a failure.

```haxe
typedef MyResult = Either<Error, String>;

var result : MyResult = Left(new Error("something smells"));

var result : MyResult = Right("the answer is 42");
```

Note that [`thx.core.Result`](http://thx-lib.org/api/thx/core/Result.html) is an abstract on top of `Either` with some additional features.

### [Nil](http://thx-lib.org/api/thx/core/Nil.html)

`Nil` is a special enum that only contains one constructor `nil` that takes no parameter. It denotes the absence of a value. It is very handy when you want to work on functions of arity 1 and you don't want to special case them to support an empty list of arguments.

```haxe
function do<T>(arg : T) { /* do magic */ }

do(nil) { /* ... */ } // use `do` with an empty argument
```

```haxe
typedef F<T> = T -> String;

// the following function satisfies the typedef above
function myF(_ : Nil) : String { /* ... */ }
```

### [Result](http://thx-lib.org/api/thx/core/Result.html)

`Result` is a wrapper (abstract) on top of `thx.core.Either`. It semantically represents the result of an operation that can either a success or a failure.

```haxe
var success : Result<String, String> = Right("victory!");

success.isSuccess; // true
success.isFailure; // false
success.value(); // "victory!"
success.error(); // null
success.optionValue(); // Some("victory!")
success.optionError(); // None

var failure : Result<String, String> = Left("oh, no ...");

failure.isSuccess; // false
failure.isFailure; // true
failure.value(); // null
failure.error(); // "oh, no ..."
failure.optionValue(); // None
failure.optionError(); // Some("oh, no ...")
```

`thx.promise.Future` always bring a result and `thx.promise.Promise` extend the concept by adding the possibility of a failure.

### [Set](http://thx-lib.org/api/thx/core/Set.html)

A `Set` is a list of unique values. Values are unique in a way that no duplicates can exist in the same `Set`. Note that uniqueness is enforced by strict phisical equality. That means that is perfectly possible to have a `Set` of class instances where the instances contain exactly the same values but are referring different objects. Primitive values like `Int`, `Float`, `String` do not incur in such cases.

`Set<T>` is an abstract built on top of `Array<T>`. Like `Array`, it is a mutable structure and shares with it most of its methods with.

```haxe
var set = Set.create();
set.add(1);
set.add(2);
set.add(3);
// again one!
set.add(1);

set.length == 3; // true!
```

A `Set` can be easily created from an `Array`:

```haxe
var s : Set<Int> = [1,2,3,1]; // note that the repetead value will be removed
```

`Set` supports boolean operations like `union`, `intersection` and `difference`:

```haxe
var s = ([1,2,3] : Set<Int>).union([2,3,4]).difference([2,3]);
// s contains [1,4]
```

Note that boolean operations return new `Set` instances and do not change the original instances.

### [Tuple](http://thx-lib.org/api/thx/core/Tuple.html)

A `Tuple` is a value containing multiple values of potentially different types. All tuples are immutable; that means that any tuple operation that seems to change the Tuple it is creating a new structure instead.

A [`Tuple0`](http://thx-lib.org/api/thx/core/Tuple0.html) contains no value and it is equivalent to `thx.core.Nil.nil`.

A [`Tuple1`](http://thx-lib.org/api/thx/core/Tuple1.html) contains one value and it is a wrapper to the value type itself.

A [`Tuple2`](http://thx-lib.org/api/thx/core/Tuple2.html), the most conventional of the tuples, is an abstract wrapper around an object of type `{ _0 : T0, _1 : T1 }`.

```haxe
var t = new Tuple2("thx", 1);
t._0; // "thx", same as t.left
t._1; // 1, same as t.right

t.flip().left; // `flip` inverts the terms of the tuple and `left` is now 1

t.dropRight(); // return a Tuple1 which in this case results in "thx"

t.with("0.123") // appends a new value to the right creating a new Tuple3
```

[`Tuple3`](http://thx-lib.org/api/thx/core/Tuple3.html), [`Tuple4`](http://thx-lib.org/api/thx/core/Tuple4.html), [`Tuple5`](http://thx-lib.org/api/thx/core/Tuple5.html) and [`Tuple6`](http://thx-lib.org/api/thx/core/Tuple6.html) work much like [`Tuple`](http://thx-lib.org/api/thx/core/Tuple2.html) but bring more values.

## helper classes

It contains a lot of useful helper classes to simplify dealing with a lot of types from the standard library.

## macro helpers

`thx.core` also includes a few helpers to more easily write and deal with macros.

## install

From the command line just type:

```bash
haxelib install thx.core
```

To use the `dev` version do:

```bash
haxelib git thx.core https://github.com/fponticelli/thx.core.git
```
