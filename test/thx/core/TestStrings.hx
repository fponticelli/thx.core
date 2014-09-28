/**
 * ...
 * @author Franco Ponticelli
 */

package thx.core;

import utest.Assert;

using thx.core.Strings;

class TestStrings {
  public function new(){}

  public function testUcwordsws() {
    var tests = [
      { expected : "Test", test : "test" },
      { expected : "Test Test", test : "test test" },
      { expected : " Test Test  Test ", test : " test test  test " },
      { expected : "Test\nTest", test : "test\ntest" },
      { expected : "Test\tTest", test : "test\ttest" },
    ];
    for (item in tests)
      Assert.equals(item.expected, item.test.capitalizeWords(true));
  }

  public function testUcwords() {
    var tests = [
      { expected : "Test", test : "test" },
      { expected : "Test Test", test : "test test" },
      { expected : " Test-Test:Test_Test : Test ", test : " test-test:test_test : test " },
      { expected : "Test\nTest", test : "test\ntest" },
      { expected : "Test\tTest", test : "test\ttest" },
    ];
    for (item in tests)
      Assert.equals(item.expected, item.test.capitalizeWords());
  }

  public function testAlphaNum() {
    var tests = [
      { expected : true, test : "a" },
      { expected : true, test : "1a" },
      { expected : false, test : " a" },
      { expected : false, test : " " },
      { expected : false, test : "" },
    ];
    for (item in tests)
      Assert.equals(item.expected, item.test.isAlphaNum());
  }

  public function testHumanize() {
    Assert.equals("hello world", Strings.humanize("helloWorld"));
    Assert.equals("my long string", Strings.humanize("my_long_string"));
    Assert.equals("ignore many", Strings.humanize("ignoreMANY"));
  }

  public function testWrapColumn() {
    var text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";

    Assert.equals(
"Lorem ipsum dolor
sit amet,
consectetur
adipisicing elit,
sed do eiusmod
tempor incididunt ut
labore et dolore
magna aliqua. Ut
enim ad minim
veniam, quis nostrud
exercitation ullamco
laboris nisi ut
aliquip ex ea
commodo consequat.",
text.wrapColumns(20));

    Assert.equals(
"    Lorem ipsum
    dolor sit amet,
    consectetur
    adipisicing
    elit, sed do
    eiusmod tempor
    incididunt ut
    labore et dolore
    magna aliqua. Ut
    enim ad minim
    veniam, quis
    nostrud
    exercitation
    ullamco laboris
    nisi ut aliquip
    ex ea commodo
    consequat.",
text.wrapColumns(20, "    "));

  }

  public function testWrapColumnPreserveNewLines() {
    var text = "Lorem ipsum dolor sit amet,\n\nconsectetur adipisicing elit";
    Assert.equals(
"Lorem ipsum dolor
sit amet,

consectetur
adipisicing elit",
text.wrapColumns(18));
  }

  public function testWrapColumnLong() {
    var text = "aaaaaaaaaa aaaa aaa aa";
    Assert.equals(
"aaaaaaaaaa
aaaa
aaa aa", text.wrapColumns(6));
  }

  public function testRepeat() {
    Assert.equals('XyXyXy', 'Xy'.repeat(3));
  }

  public function testUpTo() {
    Assert.equals('abcdef', 'abcdef'.upTo('x'));
    Assert.equals('ab', 'abcdef'.upTo('cd'));
  }

  public function testFrom() {
    Assert.equals('', 'abcdef'.from('x'));
    Assert.equals('cdef', 'abcdef'.from('cd'));
  }

  public function testAfter() {
    Assert.equals('', 'abcdef'.after('x'));
    Assert.equals('ef', 'abcdef'.after('cd'));
  }

  public function testStripTags() {
    Assert.equals('a code; x', 'a<br/> <script src="aaa">code;</script> x'.stripTags());
  }

  public function testLtrim() {
    Assert.equals('abcde', 'abcde'.trimLeft('x'));
    Assert.equals('de', 'abcde'.trimLeft('cba'));
    Assert.equals('abcde', 'abcde'.trimLeft('b'));
  }

  public function testRtrim() {
    Assert.equals('abcde', 'abcde'.trimRight('x'));
    Assert.equals('ab', 'abcde'.trimRight('ced'));
    Assert.equals('abcde', 'abcde'.trimRight('d'));
  }

  public function testTrim() {
    Assert.equals('abcde', 'abcde'.trim('x'));
    Assert.equals('cd', 'abcde'.trim('abe'));
    Assert.equals('abcde', 'abcde'.trim('bd'));
  }
}