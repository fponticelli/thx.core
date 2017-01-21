/**
 * ...
 * @author Franco Ponticelli
 */

package thx;

import utest.Assert;
using thx.Ints;
using thx.Int64s;

class TestInt64s {
  public function new() { }

  public function testRounding() {
    var tests = [
      { roundUp :  3, roundDown :  2, round :  3, num : 5, div :  2, pos : here() },
      { roundUp :  0, roundDown :  0, round :  0, num : 0, div :  2, pos : here() },
      { roundUp :  1, roundDown :  0, round :  0, num : 1, div :  4, pos : here() },

      { roundUp : -2, roundDown : -3, round : -2, num : -5, div : 2, pos : here() },
      { roundUp :  0, roundDown : -1, round :  0, num : -1, div : 4, pos : here() },

      { roundUp :  0, roundDown :  0, round :  0, num : 0, div : -2, pos : here() },
      { roundUp : -2, roundDown : -3, round : -2, num : 5, div : -2, pos : here() },
      { roundUp :  0, roundDown : -1, round :  0, num : 1, div : -4, pos : here() },
    ];
    var up : Int64,
        down : Int64,
        round : Int64,
        num : Int64,
        div : Int64;
    for(test in tests) {
      up = test.roundUp;
      down = test.roundDown;
      round = test.round;
      num = test.num;
      div = test.div;
      Assert.isTrue(round == num.divRound(div), 'expected $round but got ${num.divRound(div)} from $num.divRound($div)', test.pos);
      Assert.isTrue(up    == num.divCeil(div),  'expected $up but got ${num.divCeil(div)} from $num.divCeil($div)', test.pos);
      Assert.isTrue(down  == num.divFloor(div), 'expected $down but got ${num.divFloor(div)} from $num.divFloor($div)', test.pos);
    }
  }

  public function testAbs() {
    Assert.isTrue(Int64.ofInt(0) == Int64s.abs(Int64.ofInt(0)));
    Assert.isTrue(Int64.ofInt(1) == Int64s.abs(Int64.ofInt(1)));
    Assert.isTrue(Int64.ofInt(1) == Int64s.abs(Int64.ofInt(-1)));
    Assert.isTrue(Int64.ofInt(42) == Int64s.abs(Int64.ofInt(42)));
    Assert.isTrue(Int64.ofInt(42) == Int64s.abs(Int64.ofInt(-42)));
  }

  public function testCompare() {
    Assert.same(0, Int64s.compare(Int64.ofInt(3), Int64.ofInt(3)));
    Assert.same(1, Int64s.compare(Int64.ofInt(4), Int64.ofInt(3)));
    Assert.same(-1, Int64s.compare(Int64.ofInt(4), Int64.ofInt(5)));
    Assert.same(0, Int64s.compare(Int64.ofInt(-3), Int64.ofInt(-3)));
    Assert.same(-1, Int64s.compare(Int64.ofInt(-4), Int64.ofInt(-3)));
    Assert.same(1, Int64s.compare(Int64.ofInt(-4), Int64.ofInt(-5)));
  }

  static inline function here(?pos : haxe.PosInfos) return pos;
}
