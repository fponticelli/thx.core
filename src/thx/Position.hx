package thx;

import haxe.PosInfos;

abstract Position(PosInfos) from PosInfos to PosInfos{
  public function new(self:PosInfos){
    this = self;
  }
  @:noUsing static public function here(?pos:PosInfos):Position{
    return new Position(pos);
  } 
  @:to public function toString():String{
    return Positions.toString(this);
  }
  public var fileName(get,never)     : String;
  public function get_fileName(){
    return this.fileName;
  }   
  public var className(get,never)    : String;
  public function get_className(){
    return this.className;
  }     
  public var methodName(get,never)   : String;
  public function get_methodName(){
    return this.methodName;
  }      
  public var lineNumber(get,never)   : Int;
  public function get_lineNumber(){
    return this.lineNumber;
  }     
  public var customParams(get,never) : CustomParams;
  public function get_customParams(){
    return this.customParams == null ? this.customParams = new CustomParams(this.customParams) : this.customParams;
  }

  public function clone():Position{
    return Positions.clone(this);
  }
  public function getClassMethodString():String{
    return Positions.getClassMethodString(this);
  }
  public function getClassMethodLineString():String{
    return Positions.getClassMethodLineString(this);
  }
}
@:forward abstract CustomParams(Null<Array<Dynamic>>) from Null<Array<Dynamic>> to Null<Array<Dynamic>>{
  public function new(self){
    if(self == null){
      self = [];
    }
    this = self;
  }
}
class Positions{
  static public function toString(pos:PosInfos){
    if (pos == null) return '<unknown position>';
    return '|>[' + pos.fileName +  ']' + pos.className + "#" + pos.methodName + ":" + pos.lineNumber + '<|';
  }
  @:noUsing static public function clone(p:PosInfos){
    return create(p.fileName,p.className,p.methodName,p.lineNumber,p.customParams);
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
  @:noUsing static public function getClassMethodLineString(pos:PosInfos):String{
    var class_method = getClassMethodString(pos);
    return '$class_method@${pos.lineNumber}';
  }
  public static function withCustomParam(p:PosInfos,v:Dynamic):PosInfos{
    p = clone(p);
    if(p.customParams == null){
      p.customParams = [];
    };
    p.customParams.push(v);
    return p;
  }
}