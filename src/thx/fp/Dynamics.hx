package thx.fp;

import haxe.ds.Option;
import thx.Options;
import thx.Monoid;
import thx.Nel;
import thx.Validation;
import thx.Validation.*;
import thx.Unit;
import thx.Ints;
import thx.Floats;
import thx.fp.Dynamics;
import thx.fp.Functions.flip;
import thx.fp.Writer;

using thx.Arrays;
using thx.Functions;
using thx.Iterators;
using thx.Maps;
using thx.Options;
using thx.Objects;

class Dynamics {
  public static function parseInt(v: Dynamic): VNel<String, Int>
    return switch Type.typeof(v) {
      case TInt :   successNel(cast v);
      case TClass(name) :
        switch Type.getClassName(Type.getClass(v)) {
          case "String" if (Ints.canParse(v)) : successNel(Ints.parse(cast v));
          case other: failureNel('Cannot parse an integer value from $v (type resolved to $other)');
        };

      case other: failureNel('Cannot parse an integer value from $v (type resolved to $other)');
    };

  public static function parseFloat(v: Dynamic): VNel<String, Float>
    return switch Type.typeof(v) {
      case TInt :   successNel(cast v);
      case TFloat : successNel(cast v);
      case TClass(name) :
        switch Type.getClassName(Type.getClass(v)) {
          case "String" if (Floats.canParse(v)) : successNel(Floats.parse(cast v));
          case other: failureNel('Cannot parse a floating-point value from $v (type resolved to $other)');
        };
      case other: failureNel('Cannot parse a floating-point value from $v (type resolved to $other)');
    };

  public static function parseString(v: Dynamic): VNel<String, String>
    return switch Type.typeof(v) {
      case TClass(name) :
        switch Type.getClassName(Type.getClass(v)) {
          case "String": successNel(cast v);
          case other: failureNel('$v is not a String value (type resolved to $other)');
        };
      case other: failureNel('$v is not a String value (type resolved to $other)');
    };

  public static function parseBool(v: Dynamic): VNel<String, Bool>
    return switch Type.typeof(v) {
      case TBool: successNel(cast v);
      case TClass(name) :
        switch Type.getClassName(Type.getClass(v)) {
          case "String" if (Bools.canParse(v)) : successNel(Bools.parse(cast v));
          case other: failureNel('Cannot parse a boolean value from $v (type resolved to $other)');
        };
      case other: failureNel('Cannot parse a boolean value from $v (type resolved to $other)');
    };

  public static function parseProperty<A>(ob: {}, name: String, f: Dynamic -> VNel<String, A>): VNel<String, A> 
    return nnNel(ob.getPath(name), 'Property "$name" was not found.').flatMapV(f);

  // This demands that the parser for the field value be able to accept
  // null values, which is not the usual way of things.
  public static function parseNullableProperty<A>(ob: {}, name: String, f: Null<Dynamic> -> VNel<String, A>): VNel<String, A> {
    return f(ob.getPath(name));
  }

  public static function parseOptionalProperty<A>(ob: {}, name: String, f: Dynamic -> VNel<String, A>): VNel<String, Option<A>> {
    var property = ob.getPath(name);
    return if (property != null) f(property).map(function(a) return Some(a)) else successNel(None);
  }

  public static function parseArray<A>(v: Dynamic, f: Dynamic -> VNel<String, A>): VNel<String, Array<A>>
    return switch Type.typeof(v) {
      case TClass(name) :
        switch Type.getClassName(Type.getClass(v)) {
          case "Array": (v: Array<Dynamic>).traverseValidation(f, Nel.semigroup());
          case other: failureNel('$v is not array-valued (type resolved to $other)');
        };
      case other: failureNel('$v is not array-valued (type resolved to $other)');
    };

  public static function parseArrayIndexed<A>(v: Dynamic, f: Dynamic -> Int -> VNel<String, A>): VNel<String, Array<A>>
    return switch Type.typeof(v) {
      case TClass(name) :
        switch Type.getClassName(Type.getClass(v)) {
          case "Array": (v: Array<Dynamic>).traverseValidationIndexed(f, Nel.semigroup());
          case other: failureNel('$v is not array-valued (type resolved to $other)');
        };
      case other: failureNel('$v is not array-valued (type resolved to $other)');
    };
}
