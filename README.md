# thx.core
[![Gitter](https://badges.gitter.im/Join+Chat.svg)](https://gitter.im/fponticelli/thx.core?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/fponticelli/thx.core.svg?branch=master)](https://travis-ci.org/fponticelli/thx.core)

Generic multi-purpose library. `thx.core` aims to be the [lodash](http://lodash.com/) library for Haxe.

## Data Structures

`thx.core` provides a few data types to complete the standard library.

### [AnonymousMap](http://thx-lib.org/api/thx/AnonymousMap.html)

Wraps an anonymous object in `Map<String, T>` compatible structure.

```haxe
var map = new AnonymousMap({ name : "Franco" });

map.get("name"); // "Franco"
```

The intention of this class is not to encourage anonymous objects as data containers but to simplify the approach to untyped data like JSON results.

### [Either](http://thx-lib.org/api/thx/Either.html)

`Either` is a value container. It can contain values from two different types but only one per instance. It can be handy when you want to manage values that can be in one of two possible states. A classic example is a Result where the wrapped value can be either a success or a failure.

```haxe
typedef MyResult = Either<Error, String>;

var result : MyResult = Left(new Error("something smells"));

var result : MyResult = Right("the answer is 42");
```

Note that [`thx.Result`](http://thx-lib.org/api/thx/Result.html) is an abstract on top of `Either` with some additional features.

NOTE: Haxe v.3.2.0 introduces its own `haxe.ds.Either` type. It is 100% compatible with the one provided by thx. For that reason, thx adopts the official one when available. In the future `thx.Either` will probably be deprecated.

### [Nil](http://thx-lib.org/api/thx/Nil.html)

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

### [Result](http://thx-lib.org/api/thx/Result.html)

`Result` is a wrapper (abstract) on top of `thx.Either`. It semantically represents the result of an operation that can either a success or a failure.

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

### [Set](http://thx-lib.org/api/thx/Set.html)

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

### [Tuple](http://thx-lib.org/api/thx/Tuple2.html)

A `Tuple` is a value containing multiple values of potentially different types. All tuples are immutable; that means that any tuple operation that seems to change the Tuple it is creating a new structure instead.

A [`Tuple0`](http://thx-lib.org/api/thx/Tuple0.html) contains no value and it is equivalent to `thx.Nil.nil`.

A [`Tuple1`](http://thx-lib.org/api/thx/Tuple1.html) contains one value and it is a wrapper to the value type itself.

A [`Tuple2`](http://thx-lib.org/api/thx/Tuple2.html), the most conventional of the tuples, is an abstract wrapper around an object of type `{ _0 : T0, _1 : T1 }`.

```haxe
var t = new Tuple2("thx", 1);
t._0; // "thx", same as t.left
t._1; // 1, same as t.right

t.flip().left; // `flip` inverts the terms of the tuple and `left` is now 1

t.dropRight(); // return a Tuple1 which in this case results in "thx"

t.with("0.123") // appends a new value to the right creating a new Tuple3
```

[`Tuple3`](http://thx-lib.org/api/thx/Tuple3.html), [`Tuple4`](http://thx-lib.org/api/thx/Tuple4.html), [`Tuple5`](http://thx-lib.org/api/thx/Tuple5.html) and [`Tuple6`](http://thx-lib.org/api/thx/Tuple6.html) work much like [`Tuple`](http://thx-lib.org/api/thx/Tuple2.html) but bring more values.

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

[1,2,3].filter.fn(_ != 2); // equivalent to [1,2,3].filter(function(i) return i != 2)

[1,2,3].isEmpty(); // false

[1,2,3].map.fn(_ * 2); // [2,4,6]
```

### [Arrays](http://thx-lib.org/api/thx/Arrays.html)

Beside the usual methods to traverse, reduce, slice and arrange arrays, `Arrays` contains peculiar things like:

  * `compact` to filter out null values
  * `cross` to create cross products between 2 arrays
  * `equals` to compare each element of two arrays
  * `flatMap` and `flatten` to reduce nested arrays into flat arrays
  * `groupBy` to create `Map` from arrays
  * `sample` and `sampleOne` to extract random elements from one array
  * `shuffle` to reorder randomly an array
  * `zip`/`unzip` to create/deconstruct arrays of `Tuple`

In the `thx.Arrays` module are also defined a few specialized operations for specific type of arrays: [ArrayFloats](http://thx-lib.org/api/thx/ArrayFloats.html), [ArrayInts](http://thx-lib.org/api/thx/ArrayInts.html) and [ArrayStrings](http://thx-lib.org/api/thx/ArrayStrings.html). The numeric array variations provide methods for `average`, `sum`, `min` and `max` (plus `compact` for `Float` that removes non-finite numbers).

### [Iterators](http://thx-lib.org/api/thx/Iterators.html)

```haxe
it.isIterator() // checks that the instance has the right members to be an Iterator
```

### [Iterables](http://thx-lib.org/api/thx/Iterables.html)

```haxe
it.isIterable() // checks that the instance has the right members to be an Iterable
```

### [Floats](http://thx-lib.org/api/thx/Floats.html)

`Floats` contains extension methods to work with `Float` values. Some examples:

  * `canParse` checks if a string can be safely parsed into a `Float`. Use `parse` for the final conversion
  * `clamp` restricts a value within a given range
  * `compare` returns a value suitable for comparison
  * `interpolate` does exactly that :)
  * `nearEquals` compare two values with a small margin to account for floating precision issues
  * `wrap` ensure that the passed valeu will be included in the boundaries. If the value exceeds `max`, the value is reduced by `min` repeatedely until it falls within the range. Similar and inverted treatment is performed if the value is below `min`

### [Functions](http://thx-lib.org/api/thx/Functions.html)

Extension methods for functions. Methods are roughly distributed between [`Functions`](http://thx-lib.org/api/thx/Functions.html),  [`Functions0`](http://thx-lib.org/api/thx/Functions0.html),  [`Functions1`](http://thx-lib.org/api/thx/Functions1.html),  [`Functions2`](http://thx-lib.org/api/thx/Functions2.html) and  [`Functions3`](http://thx-lib.org/api/thx/Functions3.html) where the number suffix denotes the arity (number of arguments) of the function that are going to be extended.

  * `after` returns a function that wraps the passed function. The original function will be executed only after it has been called `n` times
  * `compose` returns a function that calls the first argument function with the result of the following one.
  * `equality` performs strict physical equality
  * `identity` is a function that returns its first argument
  * `join` creates a function that calls the 2 functions passed as arguments in sequence
  * `memoize` returns a new version of the argument function that stores the computation from the function and recycles it whenever called again
  * `negate` return a new version of a function that returns a `Bool` and transforms it so that it will return the negation of its result
  * `noop` its a function that performs no computations and doesn't return a value
  * `once` wraps and returns the argument function. `once` ensures that `f` will be called at most once even if the returned function is invoked multiple times
  * `times` creates a function that calls `callback` `n` times and returns an array of results.

### [Ints](http://thx-lib.org/api/thx/Ints.html)

Extension methods for integer values. Many methods are implemented the same as in `thx.Floats` but specialized for `Int` values. Some are methods available in `Std` or `Math` but only available for `Float`.

### [Maps](http://thx-lib.org/api/thx/Maps.html)

Extension methods for Maps.

  * `tuples` transforms a `Map<TKey, TValue>` in an `Array` of `Tuple2<TKey, TValue>`
  * `mapToObject` transforms a `Map<String, T>` into an anonymous object.

### [Objects](http://thx-lib.org/api/thx/Objects.html)

Extension methods for objects.

  * `isEmpty` returns true if the object contains no fields
  * `objectToMap` transform an object in to a map of type `Map<String, Dynamic>`
  * `size` counts the number of fields in an object
  * `values` returns an array with the values of each field (order is not guaranteed)
  * `tuples` returns an array of `Tuple2<String, Dynamic>` containing pairs of fields/values (order is not guaranteed)

### [Options](http://thx-lib.org/api/thx/Options.html)

Extension methods for the `haxe.ds.Option` type.

  * `equals` campares two `Option` values of the same type
  * `flatMap` maps the contained value using a function `T -> Option<TOut>`
  * `map` transforms a value contained in `Option<T>` to `Option<TOut>`
  * `toArray` transforms an `Option` value to an `Array`
  * `toBool` transforms an `Option` to `true` (`Some(_)`) or `false` (`None`)
  * `toOption` transforms any type T into `Option<T>`
  * `toValue` extracts the value from `Option` or returns `null`

### [Nulls](http://thx-lib.org/api/thx/Nulls.html)

`Nulls` provides extension methods that help to deal with nullable values.

  * `isNull` checks if a chain of identifier is null at any point
  * `notNull` is the negation of `isNull`
  * `opt` traverses a chain of dot/array identifiers and it returns the last value in the chain or null if any of the identifiers is not set
  * `or` is like `opt` but allows an `alt` value that replaces a `null` occurrance

```haxe
var s : String = null;
trace(s.or('b')); // prints 'b'
s = 'a';
trace(s.or('b')); // prints 'a'

// or more complex
var o : { a : { b : { c : String }}} = null;
trace((o.a.b.c).or("B")); // prints 'B'
var o = { a : { b : { c : 'A' }}};
trace((o.a.b.c).or("B")); // prints 'A'
```

Note that the parenthesis wrap the entire chain of identifiers. That means that a null check will be performed for each identifier in the chain.

Identifiers can also be getters and methods (both are invoked only once and only if the check reaches them). `Python` seems to struggle with some native methods like methods on strings.

### [Strings](http://thx-lib.org/api/thx/Strings.html)

Extension methods for `String`. Some examples:

  * `after` returns the text after the first occurance of a certain string
  * `capitalizeWords` each word in a text
  * `collapse` trims white spaces from the beginning/end of a text and reduces any sequence of more than white space to just one inside a given text
  * `isAlphaNum` returns true if the text contains only alpha-numeric characters
  * `ifEmpty` returns the either the passed value if not empty (null or "") or an alternative value.
  * `isDigitsOnly` returns true if the string contains only digits
  * `map` iterates on each character individually
  * `repeat` creates a string repeating a certain pattern `n` times
  * `stripTags` sanitize html string by removing any tag-like information
  * `wrapColumns` breaks a long string into consistently sized lines without breaking words apart.

`Strings` also defines a type alias to `StringTools`. This way by including it,
you also get all the `StringTools` extension methods:

```haxe
using thx.Strings;
```

### [Dates](http://thx-lib.org/api/thx/Dates.html)

Extension methods for `Date` and `Float`s that represent date values.

Some examples:

  * `compare` to sort `Date` values.
  * `isLeapYear`/`isInLeapYear` to find leap year about a spefici year or date.
  * `numDaysInMonth`/`numDaysInThisMonth` return the number of days in a month for a specified date.
  * `snapTo`/`snapPrev`/`snapNext` to force a date value to a close boundary (Minute, Hour, Day, Week, Month, Year).
  * `jump`/`prevX`/`nextX` to skip forward/backward by a given time delta.

`Dates` also defines a type alias to `DateTools`. This way by including it,
you also get all the `DateTools` extension methods:

```haxe
using thx.Dates;
```

### [Types](http://thx-lib.org/api/thx/Types.html)

Extension methods to use on values, types and classes.

`isAnonymousObject` returns true if the passed argument is an anonymous object.

```haxe
Types.isAnonymousObject({}); // true
```

`valueTypeToString` returns a string describing the type of any `value`.

```haxe
Types.valueTypeToString("thx"); // "String"
Types.valueTypeToString(1); // "Int"
Types.valueTypeToString(Left("some")); // "thx.Either"
```

`valueTypeInheritance` returns an array of string describing the entire inheritance
chain of the passed `value`.

`valueTypeInheritance` works on any value, not just class instances. Obviously most types will return an array of just one value.

```haxe
class B extends A {};

Types.valueTypeInheritance(new B()); // ["B", "A"]
```

### [Dynamics](http://thx-lib.org/api/thx/Dynamics.html).equals

Compares any two values checking their type first and recursively all their members for structural equality. It should work on any type. If the values passed are objects and they contain a method `equals`, it will be used to decide if the two objects match.

```haxe
Dynamics.equals({ a : 1 }, { a : 1 }); // true
Dynamics.equals(1, 2); // false
```

### [ERegs](http://thx-lib.org/api/thx/ERegs.html).escape

It escapes any characer in a string that has a special meaning when used in a regular expression.

## General Purpose Features

The following utilities have no direct relationship with standard types and just provides commonly required functionalities.

### [Timer](http://thx-lib.org/api/thx/Timer.html)

`Timer` provides several meaning to delay the execution of code. At the moment it is only implemented for platforms that have a native concept of Timer like Swf and JavaScript or c++/Neko with OpenFL or NME.

All of the Timer methods return a function with signature `Void -> Void` that can be used to cancel the timer.

```haxe
// set the execution delayed by 200ms
var cancel = Timer.delay(doSomethingLater, 200);

// cancel immediately (`doSomethingLater` will never be executed)
cancel();
```

Note that calling the cancel function multiple times have no effect after the first execution.

### [Uuid](http://thx-lib.org/api/thx/Uuid.html)

Helper class to generate [UUID](http://en.wikipedia.org/wiki/Universally_unique_identifier) strings (version 4).

```haxe
Uuid.create(); // generates something like f47ac10b-58cc-4372-a567-0e02b2c3d479
```

## Errors

Haxe brings the power of being able to use any type to throw an exception. It is not uncommon to find code that simply does `throw "my error`. There is nothing wrong with that approach except that some times, most commonly in bigger applications that use many libraries, you need to be conservative when you want to catch an exception and introduce a `catch(e : Dynamic)` to be sure to not forget any possible error. The problem with Dynamic is that you don't really know how to access the error info. The type `thx.Error` described below tries to solve this problem providing a common and generic implementation.

### [Error](http://thx-lib.org/api/thx/Error.html)

Represent a Runtime error or exception. When used with JS it inherits from the native `Error` type. It tries to bring information like error message and error location. Usage is super easy:

```haxe
throw new Error('my error message');
```

Note that `Error` will try to collect (if possible) information about the error stack and the error location using `haxe.PosInfos`.

On top of `thx.Error` a few definitions are built for very common situations.

### [AbstractMethod](http://thx-lib.org/api/thx/error/AbstractMethod.html)

Mark a method as `abstract`. If it is not implemented by a sub-type a runtime exception is thrown indicating the class/method name that is abstract and has no implementation.

```haxe
function myAbstract() {
    throw new AbstractMethod(); // no argument required
}
```

### [NotImplemented](http://thx-lib.org/api/thx/error/NotImplemented.html)

Similarly to `AbstracMethod` it is used to mark method that have not been implementd yet.

```haxe
function myNotImplemented() {
    throw new NotImplemented(); // no argument required
}
```

### [NullArgument](http://thx-lib.org/api/thx/error/NullArgument.html)

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
