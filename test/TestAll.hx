import utest.Runner;
import utest.ui.Report;

class TestAll {
	public static function addTests(runner : Runner) {
		runner.addCase(new thx.core.TestAnonymousMap());
		runner.addCase(new thx.core.TestArrays());
		runner.addCase(new thx.core.TestDefaults());
		runner.addCase(new thx.core.TestERegs());
		runner.addCase(new thx.core.TestFloats());
		runner.addCase(new thx.core.TestInts());
		runner.addCase(new thx.core.TestMaps());
		runner.addCase(new thx.core.TestObjects());
		runner.addCase(new thx.core.TestSet());
		runner.addCase(new thx.core.TestStrings());
		runner.addCase(new thx.core.TestTimer());
	}

	public static function main() {
		var runner = new Runner();
		addTests(runner);
		Report.create(runner);
		runner.run();
	}
}
