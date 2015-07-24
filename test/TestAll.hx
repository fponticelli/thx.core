import utest.Runner;
import utest.ui.Report;

class TestAll {
  public static function addTests(runner : Runner) {
    runner.addCase(new thx.TestAnonymousMap());
    runner.addCase(new thx.TestArrays());
    runner.addCase(new thx.TestAssert());
    runner.addCase(new thx.TestChar());
    runner.addCase(new thx.TestChars());
    runner.addCase(new thx.TestDates());
    runner.addCase(new thx.TestDynamics());
    runner.addCase(new thx.TestEnums());
    runner.addCase(new thx.TestERegs());
    runner.addCase(new thx.TestError());
    runner.addCase(new thx.TestFloats());
    runner.addCase(new thx.TestFunctions());
    runner.addCase(new thx.TestInts());
    runner.addCase(new thx.TestIterators());
    runner.addCase(new thx.TestMapList());
    runner.addCase(new thx.TestMaps());
    runner.addCase(new thx.TestNulls());
    runner.addCase(new thx.TestObjects());
    runner.addCase(new thx.TestPath());
    runner.addCase(new thx.TestQueryString());
    runner.addCase(new thx.TestSet());
    runner.addCase(new thx.TestStaticResource());
    runner.addCase(new thx.TestStrings());
    runner.addCase(new thx.TestLambda());
    runner.addCase(new thx.TestLambdaStaticExtension());
#if (js || flash || java)
    runner.addCase(new thx.TestTimer());
#end
    runner.addCase(new thx.TestTuple());
    runner.addCase(new thx.TestUrl());
  }

  public static function main() {
    var runner = new Runner();
    addTests(runner);
    Report.create(runner);
    runner.run();
  }
}
