import utest.Runner;
import utest.ui.Report;

class TestAll {
  public static function addTests(runner : Runner) {
    runner.addCase(new thx.TestAnonymousMap());
    runner.addCase(new thx.TestAny());
    runner.addCase(new thx.TestArrays());
    runner.addCase(new thx.TestAssert());
    runner.addCase(new thx.TestBigInt());
    runner.addCase(new thx.TestBitMatrix());
    runner.addCase(new thx.TestBitSet());
    runner.addCase(new thx.TestChar());
    runner.addCase(new thx.TestChars());
    runner.addCase(new thx.TestConvert());
    runner.addCase(new thx.TestDates());
    runner.addCase(new thx.TestDateTime());
    runner.addCase(new thx.TestDateTimeUtc());
    runner.addCase(new thx.TestDecimal());
    runner.addCase(new thx.TestDynamics());
    runner.addCase(new thx.TestEffects());
    runner.addCase(new thx.TestEithers());
    runner.addCase(new thx.TestEnums());
    runner.addCase(new thx.TestERegs());
    runner.addCase(new thx.TestError());
    runner.addCase(new thx.TestFloats());
    runner.addCase(new thx.TestFunctions());
    runner.addCase(new thx.TestHashSet());
    runner.addCase(new thx.TestInt64s());
    runner.addCase(new thx.TestInts());
    runner.addCase(new thx.TestIterables());
    runner.addCase(new thx.TestIterators());
    runner.addCase(new thx.TestLazy());
    runner.addCase(new thx.TestLocalDate());
    runner.addCase(new thx.TestLocalYearMonth());
    runner.addCase(new thx.TestLocalMonthDay());
    runner.addCase(new thx.TestMaybe());
    runner.addCase(new thx.TestNel());
    runner.addCase(new thx.TestNothing());
    runner.addCase(new thx.TestOrderedMap());
    runner.addCase(new thx.TestOrderedSet());
    runner.addCase(new thx.TestMake());
    runner.addCase(new thx.TestMaps());
    runner.addCase(new thx.TestNulls());
    runner.addCase(new thx.TestObjects());
    runner.addCase(new thx.TestOptions());
    runner.addCase(new thx.TestPath());
    runner.addCase(new thx.TestPosition());
    runner.addCase(new thx.TestRational());
    runner.addCase(new thx.TestReadonlyArray());
    runner.addCase(new thx.TestQueryString());
    runner.addCase(new thx.TestSet());
    runner.addCase(new thx.TestTypes());
    runner.addCase(new thx.TestUuid());

    runner.addCase(new thx.TestStaticResource());
    runner.addCase(new thx.TestStrings());
    runner.addCase(new thx.TestTime());
    runner.addCase(new thx.TestLambda());
    runner.addCase(new thx.TestLambdaStaticExtension());
#if (js || flash)
    runner.addCase(new thx.TestTimer());
#end
    runner.addCase(new thx.TestTuple());
    runner.addCase(new thx.TestUrl());
    runner.addCase(new thx.TestValidation());

    runner.addCase(new thx.fp.TestDynamics());
    runner.addCase(new thx.fp.TestList());
    runner.addCase(new thx.fp.TestMap());
    runner.addCase(new thx.fp.TestMonad());
    runner.addCase(new thx.fp.TestSet());
    runner.addCase(new thx.fp.TestTree());
    runner.addCase(new thx.fp.TestState());
    runner.addCase(new thx.fp.TestWriter());
    runner.addCase(new thx.fp.TestTreeBag());
  }

  public static function main() {
    #if php untyped __call__('ini_set', 'xdebug.max_nesting_level', 10000); #end
    var runner = new Runner();
    addTests(runner);
    Report.create(runner);
    runner.run();
  }
}
