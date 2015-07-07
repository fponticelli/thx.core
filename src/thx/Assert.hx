package thx;

import haxe.PosInfos;

class Assert {
  #if !no_asserts
  public static var behavior : IAssertBehavior = new DefaultAssertBehavior();
  #end

/**
Asserts successfully when the value parameter is equal to the expected one.
```haxe
Assert.equals(10, age);
```
@param expected: The expected value to check against
@param value: The value to test
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function equals(expected : Dynamic, value : Dynamic, ?msg : String , ?pos : PosInfos) {
    #if !no_asserts
    if(msg == null) msg = "expected " + Strings.quote(expected) + " but was " + Strings.quote(value);
    isTrue(expected == value, msg, pos);
    #end
  }

/**
Asserts successfully when the condition is false.
@param cond: The condition to test
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function isFalse(value : Bool, ?msg : String, ?pos : PosInfos) {
    #if !no_asserts
    if (null == msg)
      msg = "expected false";
    isTrue(value == false, msg, pos);
    #end
  }

/**
Asserts successfully when the 'value' parameter is of the of the passed `type`.
@param value: The value to test
@param type: The type to test against
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function is(value : Dynamic, type : Dynamic, ?msg : String , ?pos : PosInfos) {
    #if !no_asserts
    if (msg == null) msg = "expected type " + Types.toString(type) + " but was " + Types.valueTypeToString(value);
    isTrue(Std.is(value, type), msg, pos);
    #end
  }

/**
Asserts successfully when the value is null.
@param value: The value to test
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function isNull(value : Dynamic, ?msg : String, ?pos : PosInfos) {
    #if !no_asserts
    if (msg == null)
      msg = "expected null but was " + Strings.quote(value);
    isTrue(value == null, msg, pos);
    #end
  }

/**
Asserts successfully when the condition is true.
@param cond: The condition to test
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function isTrue(cond : Bool, ?msg : String, ?pos : PosInfos) {
    #if !no_asserts
    if(cond)
      behavior.success(pos);
    else
      behavior.fail(msg, pos);
    #end
  }

/**
Asserts successfully when the value parameter does match against the passed EReg instance.
```haxe
Assert.match(~/x/i, "haXe");
```
@param pattern: The pattern to match against
@param value: The value to test
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  public static function match(pattern : EReg, value : Dynamic, ?msg : String , ?pos : PosInfos) {
    if(msg == null) msg = "the value " + Strings.quote(value) + "does not match the provided pattern";
    isTrue(pattern.match(value), msg, pos);
  }

/**
Asserts successfully when the value parameter is not the same as the expected one.
```haxe
Assert.notEquals(10, age);
```
@param expected: The expected value to check against
@param value: The value to test
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function notEquals(expected : Dynamic, value : Dynamic, ?msg : String , ?pos : PosInfos) {
    #if !no_asserts
    if(msg == null) msg = "expected " + Strings.quote(expected) + " and test value " + Strings.quote(value) + " should be different";
    isFalse(expected == value, msg, pos);
    #end
  }

/**
Asserts successfully when the value is not null.
@param value: The value to test
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function notNull(value : Dynamic, ?msg : String, ?pos : PosInfos) {
    #if !no_asserts
    if (null == msg)
      msg = "expected not null";
    isTrue(value != null, msg, pos);
    #end
  }
}

interface IAssertBehavior {
  function success(pos : PosInfos) : Void;
  function fail(message : String, pos : PosInfos) : Void;
}

#if !no_asserts
class DefaultAssertBehavior implements IAssertBehavior {
  public function new() {}

  public function success(pos : PosInfos) {
    #if trace_asserts
    haxe.Log.trace('assert success', pos);
    #end
  }

  public function fail(message : String, pos : PosInfos)
    throw new thx.error.AssertError(message, pos);
}
#end
