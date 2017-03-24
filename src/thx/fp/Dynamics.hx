package thx.fp;

import haxe.ds.Option;
import haxe.ds.StringMap;

import thx.DateTime;
import thx.DateTimeUtc;
import thx.Dates;
import thx.Either;
import thx.Eithers.toVNel;
import thx.Ints;
import thx.Floats;
import thx.Functions.identity;
import thx.Options;
import thx.Monoid;
import thx.Nel;
import thx.Tuple;
import thx.Unit;
import thx.Validation;
import thx.Validation.*;
import thx.fp.Functions.flip;
import thx.fp.Writer;

using thx.Arrays;
using thx.Functions;
using thx.Iterators;
using thx.Maps;
using thx.Options;
using thx.Objects;

class Dynamics {
  inline public static function parseInt(v: Dynamic): VNel<String, Int>
    return parseInt0(v, identity);

  public static function parseInt0<E>(v: Dynamic, err: String -> E): VNel<E, Int>
    return switch Type.typeof(v) {
      case TInt :   successNel(cast v);
      case TClass(name) :
        switch Type.getClassName(Type.getClass(v)) {
          case "String" if (Ints.canParse(v)) : successNel(Ints.parse(cast v));
          case other: failureNel(err('Cannot parse an integer value from $v (type resolved to $other)'));
        };

      case other: failureNel(err('Cannot parse an integer value from $v (type resolved to $other)'));
    };

  inline public static function parseFloat(v: Dynamic): VNel<String, Float>
    return parseFloat0(v, identity);

  public static function parseFloat0<E>(v: Dynamic, err: String -> E): VNel<E, Float>
    return switch Type.typeof(v) {
      case TInt :   successNel(cast v);
      case TFloat : successNel(cast v);
      case TClass(name) :
        switch Type.getClassName(Type.getClass(v)) {
          case "String" if (Floats.canParse(v)) : successNel(Floats.parse(cast v));
          case other: failureNel(err('Cannot parse a floating-point value from $v (type resolved to $other)'));
        };
      case other: failureNel(err('Cannot parse a floating-point value from $v (type resolved to $other)'));
    };

  inline public static function parseString(v: Dynamic): VNel<String, String>
    return parseString0(v, identity);

  public static function parseString0<E>(v: Dynamic, err: String -> E): VNel<E, String>
    return switch Type.typeof(v) {
      case TClass(name) :
        switch Type.getClassName(Type.getClass(v)) {
          case "String": successNel(cast v);
          case other: failureNel(err('$v is not a String value (type resolved to $other)'));
        };
      case other: failureNel(err('$v is not a String value (type resolved to $other)'));
    };

  inline public static function parseNonEmptyString(v : Dynamic) : VNel<String, String>
    return parseNonEmptyString0(v, identity);

  public static function parseNonEmptyString0<E>(v : Dynamic, err: String -> E) : VNel<E, String>
    return parseString0(v, err).flatMapV(
      function(str : String) return if (str == null || str.length == 0) {
        failureNel(err('"$v" is not a non-empty String value'));
      } else {
        successNel(str);
      }
    );

  inline public static function parseBool(v: Dynamic): VNel<String, Bool>
    return parseBool0(v, identity);

  public static function parseBool0<E>(v: Dynamic, err: String -> E): VNel<E, Bool>
    return switch Type.typeof(v) {
      case TBool: successNel(cast v);
      case TClass(name) :
        switch Type.getClassName(Type.getClass(v)) {
          case "String" if (Bools.canParse(v)) : successNel(Bools.parse(cast v));
          case other: failureNel(err('Cannot parse a boolean value from $v (type resolved to $other)'));
        };
      case other: failureNel(err('Cannot parse a boolean value from $v (type resolved to $other)'));
    };

  public static function parseDate(v: Dynamic): VNel<String, Date>
    return parseString(v).flatMapV(toVNel.compose(Dates.parseDate));

  public static function parseDateTime(v : Dynamic) : VNel<String, DateTime>
    return parseString(v).flatMapV(toVNel.compose(DateTime.parse));

  public static function parseDateTimeUtc(v : Dynamic) : VNel<String, DateTimeUtc>
    return parseString(v).flatMapV(toVNel.compose(DateTimeUtc.parse));

  public static function parseLocalDate(v: Dynamic): VNel<String, LocalDate>
    return parseString(v).flatMapV(toVNel.compose(LocalDate.parse));

  public static function parseLocalYearMonth(v: Dynamic): VNel<String, LocalYearMonth>
    return parseString(v).flatMapV(toVNel.compose(LocalYearMonth.parse));

  public static function parsePlainObject(v: Dynamic) : VNel<String, {}> {
    return if (thx.Types.isAnonymousObject(v)) {
      successNel(cast v);
    } else {
      failureNel('$v is not a plain object');
    }
  }

  public static function parseOptional<E, A>(v: Null<Dynamic>, f: Dynamic -> VNel<E, A>) : VNel<E, Option<A>> {
    return if (v != null) f(v).map(Some) else successNel(None);
  }

  public static function parseOptionalOrElse<E, A>(v: Null<Dynamic>, f: Dynamic -> VNel<E, A>, defaultValue: A) : VNel<E, A> {
    return parseOptional(v, f).map.fn(_.getOrElse(defaultValue));
  }

  public static function parseProperty<E, A>(ob: {}, name: String, f: Dynamic -> VNel<E, A>, err: String -> E): VNel<E, A>
    return nnNel(ob.getPath(name), err('Property "$name" was not found.')).flatMapV(f);

  // This demands that the parser for the field value be able to accept
  // null values, which is not the usual way of things.
  public static function parseNullableProperty<E, A>(ob: {}, name: String, f: Null<Dynamic> -> VNel<E, A>): VNel<E, A> {
    return f(ob.getPath(name));
  }

  public static function parseOptionalProperty<E, A>(ob: {}, name: String, f: Dynamic -> VNel<E, A>): VNel<E, Option<A>> {
    var v = ob.getPath(name);
    return if (v != null) f(v).map(Some) else successNel(None);
  }

  public static function parseOptionalPropertyOrElse<E, A>(ob: {}, name: String, f: Dynamic -> VNel<E, A>, defaultValue : A): VNel<E, A> {
    return parseOptionalProperty(ob, name, f).map.fn(_.getOrElse(defaultValue));
  }

  public static function parseArray<E, A>(v: Dynamic, f: Dynamic -> VNel<E, A>, err: String -> E): VNel<E, Array<A>>
    return switch Type.typeof(v) {
      case TClass(name) :
        switch Type.getClassName(Type.getClass(v)) {
          case "Array": (v: Array<Dynamic>).traverseValidation(f, Nel.semigroup());
          case other: failureNel(err('$v is not array-valued (type resolved to $other)'));
        };
      case other: failureNel(err('$v is not array-valued (type resolved to $other)'));
    };

  public static function parseArrayIndexed<E, A>(v: Dynamic, f: Dynamic -> Int -> VNel<E, A>, err: String -> E): VNel<E, Array<A>>
    return switch Type.typeof(v) {
      case TClass(name) :
        switch Type.getClassName(Type.getClass(v)) {
          case "Array": (v: Array<Dynamic>).traverseValidationIndexed(f, Nel.semigroup());
          case other: failureNel(err('$v is not array-valued (type resolved to $other)'));
        };
      case other: failureNel(err('$v is not array-valued (type resolved to $other)'));
    };

  public static function parseNel<E, A>(v: Dynamic, f: Dynamic -> VNel<E, A>, err: String -> E): VNel<E, Nel<A>>
    return parseArray(v, f, err).flatMapV(
      function(xs: Array<A>) {
        return Nel.fromArray(xs).cata(failureNel(err('$v is an empty array; at least one element must be present.')), successNel);
      }
    );


  public static function parseStringMap<E, K, V>(v: Dynamic, f: Dynamic -> String -> VNel<E, V>, err: String -> E): VNel<E, std.Map<String, V>> {
    return if (Types.isAnonymousObject(v)) {
      Reflect.fields(v).traverseValidation(
        function(field: String) return f(Reflect.getProperty(v, field), field).map(Tuple.of.bind(field, _)),
        Nel.semigroup()
      ).map(Arrays.toStringMap);
    } else {
      failureNel(err('$v is not object-valued (type resolved to ${Type.typeof(v)})'));
    };
  }

  public static function parseMap<E, K, V>(v: Dynamic, f: String -> Dynamic -> VNel<E, Tuple<K, V>>, keyOrder: Ord<K>, err: String -> E): VNel<E, thx.fp.Map<K, V>> {
    return if (Types.isAnonymousObject(v)) {
      Reflect.fields(v).traverseValidation(
        function(field: String) return f(field, Reflect.getProperty(v, field)),
        Nel.semigroup()
      ).flatMapV(
        function(tuples) return Arrays.toMap(tuples, keyOrder).leftMap(
          function(collidingKeys) return collidingKeys.map(
            function(key) return err('Key ${key} occurred multiple types in in object $v')
          )
        )
      );
    } else {
      failureNel(err('$v is not object-valued (type resolved to ${Type.typeof(v)})'));
    };
  }

  public static function parseTuple2<Err, A, B>(v: Dynamic, fa: Dynamic -> VNel<Err, A>, fb: Dynamic -> VNel<Err, B>, err: String -> Err): VNel<Err, thx.Tuple<A, B>> {
    return if (Types.isAnonymousObject(v)) {
      val2(
        Tuple.of,
        parseProperty(v, "_0", fa, err),
        parseProperty(v, "_1", fb, err),
        Nel.semigroup()
      );
    } else {
      failureNel(err('$v is not a tuple2-object (type resolved to ${Type.typeof(v)})'));
    };
  }

  public static function parseTuple3<Err, A, B, C>(v: Dynamic, fa: Dynamic -> VNel<Err, A>, fb: Dynamic -> VNel<Err, B>, fc: Dynamic -> VNel<Err, C>, err: String -> Err): VNel<Err, thx.Tuple3<A, B, C>> {
    return if (Types.isAnonymousObject(v)) {
      val3(
        Tuple3.of,
        parseProperty(v, "_0", fa, err),
        parseProperty(v, "_1", fb, err),
        parseProperty(v, "_2", fc, err),
        Nel.semigroup()
      );
    } else {
      failureNel(err('$v is not a tuple3-object (type resolved to ${Type.typeof(v)})'));
    };
  }

  public static function parseTuple4<Err, A, B, C, D>(v: Dynamic, fa: Dynamic -> VNel<Err, A>, fb: Dynamic -> VNel<Err, B>, fc: Dynamic -> VNel<Err, C>, fd: Dynamic -> VNel<Err, D>, err: String -> Err): VNel<Err, thx.Tuple4<A, B, C, D>> {
    return if (Types.isAnonymousObject(v)) {
      val4(
        Tuple4.of,
        parseProperty(v, "_0", fa, err),
        parseProperty(v, "_1", fb, err),
        parseProperty(v, "_2", fc, err),
        parseProperty(v, "_3", fd, err),
        Nel.semigroup()
      );
    } else {
      failureNel(err('$v is not a tuple4-object (type resolved to ${Type.typeof(v)})'));
    };
  }

  public static function parseTuple5<Err, A, B, C, D, E>(v: Dynamic, fa: Dynamic -> VNel<Err, A>, fb: Dynamic -> VNel<Err, B>, fc: Dynamic -> VNel<Err, C>, fd: Dynamic -> VNel<Err, D>, fe: Dynamic -> VNel<Err, E>, err: String -> Err): VNel<Err, thx.Tuple5<A, B, C, D, E>> {
    return if (Types.isAnonymousObject(v)) {
      val5(
        Tuple5.of,
        parseProperty(v, "_0", fa, err),
        parseProperty(v, "_1", fb, err),
        parseProperty(v, "_2", fc, err),
        parseProperty(v, "_3", fd, err),
        parseProperty(v, "_4", fe, err),
        Nel.semigroup()
      );
    } else {
      failureNel(err('$v is not a tuple5-object (type resolved to ${Type.typeof(v)})'));
    };
  }

  public static function parseTuple6<Err, A, B, C, D, E, F>(v: Dynamic, fa: Dynamic -> VNel<Err, A>, fb: Dynamic -> VNel<Err, B>, fc: Dynamic -> VNel<Err, C>, fd: Dynamic -> VNel<Err, D>, fe: Dynamic -> VNel<Err, E>, ff: Dynamic -> VNel<Err, F>, err: String -> Err): VNel<Err, thx.Tuple6<A, B, C, D, E, F>> {
    return if (Types.isAnonymousObject(v)) {
      val6(
        Tuple6.of,
        parseProperty(v, "_0", fa, err),
        parseProperty(v, "_1", fb, err),
        parseProperty(v, "_2", fc, err),
        parseProperty(v, "_3", fd, err),
        parseProperty(v, "_4", fe, err),
        parseProperty(v, "_5", ff, err),
        Nel.semigroup()
      );
    } else {
      failureNel(err('$v is not a tuple6-object (type resolved to ${Type.typeof(v)})'));
    };
  }
}
