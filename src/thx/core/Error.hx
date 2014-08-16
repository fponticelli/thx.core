package thx.core;

import haxe.PosInfos;
import haxe.CallStack;

class Error #if js extends JSError #end {
	public static function fromDynamic(err : Dynamic, ?pos : PosInfos) : Error {
		if(Std.is(err, Error))
			return cast err;
		return new Error(""+err, null, pos);
	}
#if !js
	public var message(default, null) : String;
#end
	public var stack(default, null) : Array<StackItem>;
	public var pos(default, null) : PosInfos;
	public function new(message : String, ?stack : Array<StackItem>, ?pos : PosInfos) {
		this.message = message;
		if(null == stack) {
			stack = CallStack.exceptionStack();
			if(stack.length == 0)
				stack = CallStack.callStack();
		}
		this.stack = stack;
		this.pos = pos;
	}

#if !js
	public function toString()
		return message + "from: " + pos.className + "." + pos.methodName + "() at " + pos.lineNumber + "\n\n" + CallStack.toString(stack);
#end
}

#if js
@:native('Error')
extern class JSError {
	public var message(default, null) : String;
	public function toString() : String;
}
#end