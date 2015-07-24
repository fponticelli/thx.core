package thx;

import utest.Assert;
import thx.Error;
import thx.Path;

class TestPath {
  public function new() { }

  public function testIsRelativeAndIsAbsolute() {
    var rel : Path = "a/b",
        abs : Path = "/a/b";
    Assert.isTrue(rel.isRelative());
    Assert.isFalse(rel.isAbsolute());
    Assert.isTrue(abs.isAbsolute());
    Assert.isFalse(abs.isRelative());
  }

  public function testTo() {
    var path1 : Path = "/a/b/c",
        path2 : Path = "/a/d",
        path3 : Path = "/x/y/z";
    Assert.equals('../../d', path1.to(path2).toString());
    Assert.equals('../../../x/y/z', path1.to(path3).toString());
    Assert.equals('../b/c', path2.to(path1).toString());
  }

  public function testUp() {
    Assert.equals('/a/b', ('/a/b/c/' : Path).up().toString());
    Assert.equals('/', ('/a' : Path).up().up().toString());
  }

  public function testDir() {
    Assert.equals('/a/b', ("/a/b/c" : Path).dir());
    Assert.equals('a/b',  ("a/b/c" : Path).dir());
    Assert.equals('.',  ("a" : Path).dir());
    Assert.equals('.',  (".." : Path).dir());
  }

  public function testBase() {
    var path : Path = "/a/b.c";
    Assert.equals('b.c', path.base());
    Assert.equals('b', path.base('.c'));
    Assert.equals('b.', path.base('c'));
    Assert.equals('b.c', path.base('.d'));
  }

  public function testExt() {
    var path : Path = "";
    Assert.equals('c', ('/a/b.c' : Path).ext());
    Assert.equals('', ('/a/b/c' : Path).ext());
  }

  public function testSep() {
    var path : Path = "/path/to/file.png",
        win = path.toWin32("C:");
    Assert.equals('/', path.sep);
    Assert.equals('\\', win.sep);
    Assert.isTrue(path.isPosix());
    Assert.isFalse(path.isWin32());
    Assert.isTrue(win.isWin32());
    Assert.isFalse(win.isPosix());
  }

  public function testJoin() {
    Assert.equals('/a/b/c', (('/a/x' : Path) / ('../b/c' : Path)).toString());
    Assert.equals('b/c', (('../x' : Path) / ('../b/c' : Path)).toString());
    Assert.equals('/b/c', (('/a/x' : Path) / ('/b/c' : Path)).toString());
  }

  public function testJoinString() {
    Assert.equals('/a/b/c', (('/a/b' : Path) / "c").toString());
    Assert.equals('../../b/c', (('../x' : Path) / "../d").toString());
  }

  public function testToWin32ToPosix() {
    var path : Path = "/path/to/file.png",
        win = path.toWin32("C:");
    Assert.equals("C:\\path\\to\\file.png", win.toString());
    Assert.equals("/path/to/file.png", win.toPosix().toString());
  }

  public function testNormalization() {
    Assert.equals('c', ('a/.././b/../c/.' : Path).toString());
    Assert.equals('a/c', ('a/./b/../c/.' : Path).toString());
    Assert.equals('/b/c', ('/a/.././b/./c/.' : Path).toString());
    Assert.equals('../../c', ('a/../../../b/../c/.' : Path).toString());
  }

  public function testToString() {
    Assert.equals('.', ('.' : Path).toString());
    Assert.equals('..', ('..' : Path).toString());
    Assert.equals('..', ('../' : Path).toString());
    Assert.equals('/', ('/' : Path).toString());
    Assert.equals('/a/a', ('/a/a' : Path).toString());
    Assert.equals('/a/a', ('/a/a/' : Path).toString());
  }
}
