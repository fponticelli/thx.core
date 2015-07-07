package thx;

import haxe.PosInfos;

class Assert {
  #if !no_asserts
  public static var behavior : IAssertBehavior = new DefaultAssertBehavior();
  #end
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
