import utest.Runner;
import utest.ui.Report;

class TestAll {
	public static function addTests(runner : Runner) {
		runner.addCase(new thx.core.TestAnonymousMap());
		runner.addCase(new thx.core.TestArrays());
		runner.addCase(new thx.core.TestDates());
		runner.addCase(new thx.core.TestDynamics());
		runner.addCase(new thx.core.TestERegs());
		runner.addCase(new thx.core.TestError());
		runner.addCase(new thx.core.TestFloats());
		runner.addCase(new thx.core.TestFunctions());
		runner.addCase(new thx.core.TestInts());
		runner.addCase(new thx.core.TestMaps());
		runner.addCase(new thx.core.TestNulls());
		runner.addCase(new thx.core.TestObjects());
		runner.addCase(new thx.core.TestSet());
		runner.addCase(new thx.core.TestStrings());
#if (js || flash || java)
		runner.addCase(new thx.core.TestTimer());
#end
		runner.addCase(new thx.core.TestTuple());
	}

	public static function main() {
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
}
