package thx.core;

import haxe.PosInfos;
import haxe.CallStack;

/**
Defines a generic Error type. When the target platform is JS, `Error` extends the native
`js.Error` type.
**/
class Error #if js extends js.Error #end {
/**
It creates an instance of Error from any value.

If `err` is already an instance of `Error`, it is returned and nothing is created.
**/
  public static function fromDynamic(err : Dynamic, ?pos : PosInfos) : Error {
    if(Std.is(err, Error))
      return cast err;
    return new Error(""+err, null, pos);
  }

#if !js
/**
The text message associated with the error.
**/
  public var message(default, null) : String;
#end
/**
The location in code where the error has been instantiated.
**/
  public var pos(default, null) : PosInfos;

/**
The collected error stack.
**/
  public var stackItems(default, null) : Array<StackItem>;

/**
The `Error` constructor only requires a steing message. `stack` and `pos` are automatically
populate but can be provided if preferred.
**/
  public function new(message : String, ?stack : Array<StackItem>, ?pos : PosInfos) {
#if js
    super(message);
#else
    this.message = message;
#end
    if(null == stack) {
      stack = CallStack.exceptionStack();
      if(stack.length == 0)
        stack = CallStack.callStack();
    }
    this.stackItems = stack;
    this.pos = pos;
  }

  public function toString()
    return message + "from: " + pos.className + "." + pos.methodName + "() at " + pos.lineNumber + "\n\n" + CallStack.toString(stackItems);
}