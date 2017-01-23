package thx;

using thx.Arrays;

import haxe.PosInfos;

@:forward abstract Position(PosInfos) from PosInfos to PosInfos{
  @:noUsing static public function here(?pos:PosInfos):Position{
    return pos;
  } 
  @:to public function toString():String{
    return Positions.toString(this);
  }
  public var customParams(get,never) : CustomParams<Dynamic>;
  public function get_customParams(){
    return this.customParams == null ? this.customParams = new CustomParams(this.customParams) : this.customParams;
  }

  public function copy():Position{
    return Positions.copy(this);
  }
  public function getClassMethodString():String{
    return Positions.getClassMethodString(this);
  }
}
@:forward abstract CustomParams<T>(Array<T>) from Array<T> to Array<T>{
  public function new(self){
    if(self == null){
      self = [];
    }
    this = self;
  }
}
class Positions{
  static public function toString(pos:PosInfos){
    var module_is_class = false;
    var file_name       = pos.fileName.split(".")[0];
    var class_name_coll = pos.className.split(".");
    if(file_name == class_name_coll.last()){
      module_is_class = true;
    }
    var out = [];
    if (module_is_class){
      out = class_name_coll;
    }else{
      var head = class_name_coll.pop();
      class_name_coll.append(file_name);
      class_name_coll.append(head);
    }
    var header = class_name_coll.join(".");
    return header + "?L=" +  pos.lineNumber + '#' + pos.methodName;
  }
  @:noUsing static public function copy(p:PosInfos){
    return create(p.fileName,p.className,p.methodName,p.lineNumber,p.customParams.copy());
  }
  @:noUsing static public function create(fileName,className,methodName,lineNumber:Null<Int>,?customParams):PosInfos{
    return {
      fileName   : fileName,
      className  : className,
      methodName : methodName,
      lineNumber : lineNumber,
      customParams : customParams
    };
  }
  @:noUsing static public function getClassMethodString(pos:PosInfos):String{
    return '${pos.className}#${pos.methodName}';
  }
  public static function withCustomParam(p:PosInfos,v:Dynamic):PosInfos{
    p = copy(p);
    if(p.customParams == null){
      p.customParams = [];
    };
    p.customParams.push(v);
    return p;
  }
}