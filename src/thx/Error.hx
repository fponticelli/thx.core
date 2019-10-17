package thx;

import haxe.PosInfos;
import haxe.CallStack;
import thx.error.ErrorWrapper;

/**
Defines a generic Error type. When the target platform is JS, `Error` extends the native
`js.lib.Error` type.
**/
class Error #if js extends js.lib.Error #end {
/**
It creates an instance of Error from any value.

If `err` is already an instance of `Error`, it is returned and nothing is created.
**/
  public static function fromDynamic(err: Dynamic, ?pos: PosInfos): Error {
    if(Std.is(err, Error))
      return cast err;
    return new ErrorWrapper(""+err, err, null, pos);
  }

#if !js
/**
The text message associated with the error.
**/
  public var message(default, null): String;
#end
/**
The location in code where the error has been instantiated.
**/
  public var pos(default, null): PosInfos;

/**
The collected error stack.
**/
  public var stackItems(default, null): Array<StackItem>;

/**
The `Error` constructor only requires a string message. `stack` and `pos` are automatically
populated, but can be provided if preferred.
**/
  public function new(message: String, ?stack: Array<StackItem>, ?pos: PosInfos) {
#if js
    super(message);
#end
    this.message = message;

    if(null == stack) {
      stack = try CallStack.exceptionStack() catch(e: Dynamic) [];
      if(stack.length == 0)
        stack = try CallStack.callStack() catch(e: Dynamic) [];
    }
    this.stackItems = stack;
    this.pos = pos;
  }

  public function toString()
    return message + "\nfrom: " + getPosition() + "\n\n" + stackToString();

  public function getPosition()
    return pos.className + "." + pos.methodName + "() at " + pos.lineNumber;

  public function stackToString()
    return CallStack.toString(stackItems);
}
