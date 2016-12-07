package thx;

import utest.Assert.*;

import thx.Position;

class TestPosition{
  public function new(){
  }
  public function test(){
    var pos = Position.here();
    equals("|>[TestPosition.hx]thx.TestPosition#test:11<|",'$pos');
    equals("thx.TestPosition#test",pos.getClassMethodString());
    equals("thx.TestPosition#test@11",pos.getClassMethodLineString());
  }
}