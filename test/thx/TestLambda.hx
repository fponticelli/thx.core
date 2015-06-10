package thx;
import utest.Assert;
import thx.Functions.*;
import thx.Conditions.*;

class TestLambda {
  public function new() { }

  public function testFunctions() {
    Assert.same([2,3], [1,2].map(fn(_+1)));

    Assert.equals(0, fn((0))());
    Assert.equals(2, fn((_0))(2));
    Assert.equals(3, fn(_0+_1)(1,2));
    Assert.equals(6, fn(_0+_1+_2)(1,2,3));
    Assert.equals(10, fn(_0+_1+_2+_3)(1,2,3,4));
    Assert.equals(15, fn(_0+_1+_2+_3+_4)(1,2,3,4,5));

    Assert.equals(1, fn(Std.parseInt(_0))("1"));
    Assert.equals(1, fn(Std.parseInt(_))("1"));
    Assert.equals(1, fn(_0)(1));
    Assert.equals(3, fn(_0+_1)(1,2));
    Assert.equals(6, fn(_0+_1+_2)(1,2,3));
    Assert.equals(10, fn(_0+_1+_2+_3)(1,2,3,4));
    Assert.equals(15, fn(_0+_1+_2+_3+_4)(1,2,3,4,5));

    Assert.equals(1, fn(_)(1));
    Assert.equals(3, fn(_+_1)(1,2));
    Assert.equals(6, fn(_+_1+_2)(1,2,3));
    Assert.equals(10, fn(_+_1+_2+_3)(1,2,3,4));
    Assert.equals(15, fn(_+_1+_2+_3+_4)(1,2,3,4,5));

    Assert.equals("Test 1", fn('Test $_')('1'));
    Assert.equals("Test 1+2", fn('Test $_0+$_1')('1', '2'));
    Assert.equals("BA", fn('$_1$_0')("A", "B"));
    Assert.equals("21", fn({ var _2a = 2; '$_2a$_0'; })("1"));
    Assert.equals("$_1$_0", fn("$_1$_0")());
    Assert.equals("$_0", fn('$$_0')());
  }


  public function testForms() {
    with(Assert,{
      _.equals(1,1);

      var check1 = 0;
      when(1==1,{
        _.equals(1,1);
        check1 = 1;
      });
      _.equals(check1,1);

      var check2 = 0;
      unless(1==1,{
        _.equals(1,1);
        check2 = 1;
      });
      _.equals(check2,0);

      var check3 = 0;
      unless(1!=1,{
        _.equals(1,1);
        check3 = 1;
      });
      _.equals(check3,1);

      var check5 = 0;
      when(and(1==1,2==2),{
        _.equals(1,1);
        check5 = 1;
      });
      _.equals(check5,1);

      var check6 = 0;
      when(or(1==2,2==2),{
        _.equals(1,1);
        check6 = 1;
      });
      _.equals(check6,1);

      _.equals(false,not(true));
      _.equals(true,not(false));

    });
  }

}
