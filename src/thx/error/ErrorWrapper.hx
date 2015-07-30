package thx.error;

import haxe.PosInfos;
import haxe.CallStack;

/**
An error that keeps a reference to an internal error.

The internal error is stored as Dynamic to keep its usage flexible.
*/
class ErrorWrapper extends thx.Error {
  public var innerError : Dynamic;
  public function new(message : String, innerError : Dynamic, ?stack : Array<StackItem>, ?pos : PosInfos) {
    super(message, stack, pos);

    this.innerError = innerError;
  }
}
