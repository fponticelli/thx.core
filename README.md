# thx.core

[![Build Status](https://travis-ci.org/fponticelli/thx.core.svg?branch=master)](https://travis-ci.org/fponticelli/thx.core)

[![Sauce Test Status](https://saucelabs.com/browser-matrix/thx-core.svg)](https://saucelabs.com/u/thx-core)

Generic multi-purpose library. `thx.core` aims to be the [lodash](http://lodash.com/) library for Haxe.

## Data Structures

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

### [Tuple](http://thx-lib.org/api/thx/core/Tuple2.html)

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

## Type Helpers

`thx.core` also contains a lot of useful helper classes to simplify dealing with a lot of types from the standard library.

Most methods described below assume that the respective types have been required using `using` and are used as type extensions.

### Arrays/Iterators/Iterables

Similarly to `Lambda`, `Arrays`/`Iterators`/`Iterables` provide extension methods to work with collections. They share most of the methods and are repeated to avoid useless casting or conversions and to provide optimizations where possible.

Some examples of the common features:

```haxe
[1,2,3].all(function(i) return i > 1); // false
[1,2,3].any(function(i) return i > 1); // true

// filter works for any Iterator/Iterable like the normal Array.filter
[1,2,3].filter(Ints.isOdd); // [1,3]

[1,2,3].filterPluck(_ != 2); // equivalent to [1,2,3].filter(function(i) return i != 2)

[1,2,3].isEmpty(); // false

[1,2,3].pluck(_ * 2); // [2,4,6]
```

### [Arrays](http://thx-lib.org/api/thx/core/Arrays.html)

Beside the usual methods to traverse, reduce, slice and arrange arrays, `Arrays` contains peculiar things like:

  * `compact` to filter out null values
  * `cross` to create cross products between 2 arrays
  * `equals` to compare each element of two arrays
  * `flatMap` and `flatten` to reduce nested arrays into flat arrays
  * `groupBy` to create `Map` from arrays
  * `sample` and `sampleOne` to extract random elements from one array
  * `shuffle` to reorder randomly an array
  * `zip`/`unzip` to create/deconstruct arrays of `Tuple`

In the `thx.core.Arrays` module are also defined a few specialized operations for specific type of arrays: [ArrayFloats](http://thx-lib.org/api/thx/core/ArrayFloats.html), [ArrayInts](http://thx-lib.org/api/thx/core/ArrayInts.html) and [ArrayStrings](http://thx-lib.org/api/thx/core/ArrayStrings.html). The numeric array variations provide methods for `average`, `sum`, `min` and `max` (plus `compact` for `Float` that removes non-finite numbers).

### [Iterators](http://thx-lib.org/api/thx/core/Iterators.html)

```haxe
it.isIterator() // checks that the instance has the right members to be an Iterator
```

### [Iterables](http://thx-lib.org/api/thx/core/Iterables.html)

```haxe
it.isIterable() // checks that the instance has the right members to be an Iterable
```

### [Floats](http://thx-lib.org/api/thx/core/Floats.html)

???

### [Functions](http://thx-lib.org/api/thx/core/Functions.html)

???

### [Ints](http://thx-lib.org/api/thx/core/Ints.html)

???

### [Maps](http://thx-lib.org/api/thx/core/Maps.html)

???

### [Objects](http://thx-lib.org/api/thx/core/Objects.html)

???

### [Options](http://thx-lib.org/api/thx/core/Options.html)

???

### [Nulls](http://thx-lib.org/api/thx/core/Nulls.html)

???

### [Strings](http://thx-lib.org/api/thx/core/Strings.html)

???

### [Types](http://thx-lib.org/api/thx/core/Types.html)

???

### [Dynamics](http://thx-lib.org/api/thx/core/Dynamics.html).equals

Compares any two values checking their type first and recursively all their members for structural equality. It should work on any type. If the values passed are objects and they contain a method `equals`, it will be used to decide if the two objects match.

```haxe
Dynamics.equals({ a : 1 }, { a : 1 }); // true
Dynamics.equals(1, 2); // false
```

### [ERegs](http://thx-lib.org/api/thx/core/ERegs.html).escape

It escapes any characer in a string that has a special meaning when used in a regular expression.

## General Purpose Features

The following utilities have no direct relationship with standard types and just provides commonly required functionalities.

### [Timer](http://thx-lib.org/api/thx/core/Timer.html)

`Timer` provides several meaning to delay the execution of code. At the moment it is only implemented for platforms that have a native concept of Timer like Swf and JavaScript or c++/Neko with OpenFL or NME.

All of the Timer methods return a function with signature `Void -> Void` that can be used to cancel the timer.

```haxe
// set the execution delayed by 200ms
var cancel = Timer.delay(doSomethingLater, 200);

// cancel immediately (`doSomethingLater` will never be executed)
cancel();
```

Note that calling the cancel function multiple times have no effect after the first execution.

### [UUID](http://thx-lib.org/api/thx/core/UUID.html)

Helper class to generate [UUID](http://en.wikipedia.org/wiki/Universally_unique_identifier) strings (version 4).

```haxe
UUID.create(); // generates something like f47ac10b-58cc-4372-a567-0e02b2c3d479
```

## Errors

Haxe brings the power of being able to use any type to throw an exception. It is not uncommon to find code that simply does `throw "my error`. There is nothing wrong with that approach except that some times, most commonly in bigger applications that use many libraries, you need to be conservative when you want to catch an exception and introduce a `catch(e : Dynamic)` to be sure to not forget any possible error. The problem with Dynamic is that you don't really know how to access the error info. The type `thx.core.Error` described below tries to solve this problem providing a common and generic implementation.

### [Error](http://thx-lib.org/api/thx/core/Error.html)

Represent a Runtime error or exception. When used with JS it inherits from the native `Error` type. It tries to bring information like error message and error location. Usage is super easy:

```haxe
throw new Error('my error message');
```

Note that `Error` will try to collect (if possible) information about the error stack and the error location using `haxe.PosInfos`.

On top of `thx.core.Error` a few definitions are built for very common situations.

### [AbstractMethod](http://thx-lib.org/api/thx/core/error/AbstractMethod.html)

Mark a method as `abstract`. If it is not implemented by a sub-type a runtime exception is thrown indicating the class/method name that is abstract and has no implementation.

```haxe
function myAbstract() {
    throw new AbstractMethod(); // no argument required
}
```

### [NotImplemented](http://thx-lib.org/api/thx/core/error/NotImplemented.html)

Similarly to `AbstracMethod` it is used to mark method that have not been implementd yet.

```haxe
function myNotImplemented() {
    throw new NotImplemented(); // no argument required
}
```

### [NullArgument](http://thx-lib.org/api/thx/core/error/NullArgument.html)

Checks that a certain argument of a function is not `null` and throws an exception otherwise.

```haxe
function myMethod(value : String) {
    NullArgument.throwIfNull(value);
}
```

With arguments of type `Array`, `String`, `Iterator` or `Iterable`, it is also possible to check for emptyness:

```haxe
function myMethod(value : String) {
    NullArgument.throwIfEmpty(value); // check that value is not `null` but also not empty ("")
}
```

## Macro Helpers

### [Macros](http://thx-lib.org/api/thx/macro/Macros.html)

Helper methods to use inside macro context.

### [MacroTypes](http://thx-lib.org/api/thx/macro/MacroTypes.html)

Several utility function to extract type information from macro types and expressions.

## Install

From the command line just type:

```bash
haxelib install thx.core
```

To use the `dev` version do:

```bash
haxelib git thx.core https://github.com/fponticelli/thx.core.git
```
