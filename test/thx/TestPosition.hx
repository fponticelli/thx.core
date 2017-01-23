package thx;

import utest.Assert.*;

import thx.Position;

class TestPosition{
  public function new(){
  }
  public function test(){
    var pos = Position.here();
    equals("thx.TestPosition?L=11#test",'$pos');
    equals("thx.TestPosition#test",pos.getClassMethodString());
    equals("thx.TestPosition.FileNameNotModule?L=19#get",FileNameNotModule.get().toString());
  }
}
class FileNameNotModule{
  static public function get(){
    return Position.here();
  }
}