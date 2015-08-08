package thx;

import utest.Assert;
import thx.Time;
using haxe.Int64;

class TestTime {
  public function new() {}

  public function testBasics() {
    var time = Time.createDays(10,9,8,7,6);
    Assert.equals(   10, time.days);
    Assert.equals(    9, time.hours);
    Assert.equals(    8, time.minutes);
    Assert.equals(    7, time.seconds);
    Assert.equals(    6, time.milliseconds);
    Assert.equals( 6000, time.microseconds);
    Assert.equals(60000, time.ticksInSecond);

    Assert.equals(           10 , time.totalDays.toInt());
    Assert.equals(          249 , time.totalHours.toInt());
    Assert.equals(        14948 , time.totalMinutes.toInt());
    Assert.equals(       896887 , time.totalSeconds.toInt());
    Assert.equals(    896887006 , time.totalMilliseconds.toInt());
    Assert.equals("896887006000", time.totalMicroseconds.toStr());
  }

  public function testFromString() {
    var time : Time = "125:55:45.123";
    Assert.equals(   5,  time.days);
    Assert.equals('125', time.totalHours.toStr());
    Assert.equals(   5,  time.hours);
    Assert.equals(  55,  time.minutes);
    Assert.equals(  45,  time.seconds);
    Assert.equals( 123,  time.milliseconds);

    Assert.equals("125:55:45.123", time.toString());
    Assert.equals("89:25:30.005", ("3.17:25:30.005" : Time).toString());
    Assert.equals("-89:25:30.05", ("-3.17:25:30.05" : Time).toString());
  }
}
