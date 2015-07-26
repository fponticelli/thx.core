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

  public function testPathTo() {
    var path1 : Path = "/a/b/c",
        path2 : Path = "/a/d",
        path3 : Path = "/x/y/z",
        path4 : Path = "a/b/c",
        path5 : Path = "x/y/z";
    Assert.equals('../../d', path1.pathTo(path2).toString());
    Assert.equals('../../../x/y/z', path1.pathTo(path3).toString());
    Assert.equals('../b/c', path2.pathTo(path1).toString());

    Assert.equals('/a/b/c/a/b/c', path1.pathTo(path4).toString());
    Assert.equals('/a/d', path5.pathTo(path2).toString());
    Assert.equals('a/b/c/x/y/z', path4.pathTo(path5).toString());
  }

  public function testUp() {
    Assert.equals('/a/b', ('/a/b/c/' : Path).up().toString());
    Assert.equals('/', ('/a' : Path).up(2).toString());
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
    Assert.isTrue(path.isNix());
    Assert.isFalse(path.isWin32());
    Assert.isTrue(win.isWin32());
    Assert.isFalse(win.isNix());
  }

  public function testJoin() {
    Assert.equals('/a/b/c', (('/a/x' : Path) / ('../b/c' : Path)).toString());
    Assert.equals('../b/c', (('../x' : Path) / ('../b/c' : Path)).toString());
    Assert.equals('/b/c', (('/a/x' : Path) / ('/b/c' : Path)).toString());
  }

  public function testJoinString() {
    Assert.equals('/a/b/c', (('/a/b' : Path) / "c").toString());
    Assert.equals('../d', (('../x' : Path) / "../d").toString());
  }

  public function testToWin32ToNix() {
    var path : Path = "/path/to/file.png",
        win = path.toWin32();
    Assert.equals("C:\\path\\to\\file.png", win.toString());
    Assert.equals("/path/to/file.png", win.toNix().toString());

    path = "path/to/file.png";
    win = path.toWin32();
    Assert.equals("path\\to\\file.png", win.toString());
    Assert.equals("path/to/file.png", win.toNix().toString());
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
    Assert.equals('/', ('/../' : Path).toString());
    Assert.equals('/', ('/' : Path).toString());
    Assert.equals('/a/a', ('/a///a' : Path).toString());
    Assert.equals('/a/a', ('/a/a/' : Path).toString());
    Assert.equals('.', ('a/..' : Path).toString());
    Assert.equals('a', ('a' : Path).toString());
  }

  public function testNormalize() {
    var p = Path.raw(["/", "/", "a/*>b"]);
    Assert.isFalse(p.isValid());
    p = p.normalize();
    Assert.isTrue(p.isValid());
    Assert.equals("/a_*>b", p.toString());
    p = p.toWin32();
    Assert.isFalse(p.isValid());
    p = p.normalize();
    Assert.isTrue(p.isValid());
    Assert.equals("C:\\a___b", p.toString());
  }

  public function testRoot() {
    var root : Path = "C:\\";
    Assert.isFalse(root.isNix());
    Assert.isTrue(root.isWin32());
    Assert.isTrue(root.isAbsolute());
    Assert.isFalse(root.isRelative());
    Assert.isTrue(root.isRoot());
    Assert.equals("C:\\", root.toString());
    Assert.equals(".", root.asRelative().toString());

    root = "/";
    Assert.isTrue(root.isNix());
    Assert.isFalse(root.isWin32());
    Assert.isTrue(root.isAbsolute());
    Assert.isFalse(root.isRelative());
    Assert.isTrue(root.isRoot());
    Assert.equals("/", root.toString());
    Assert.equals(".", root.asRelative().toString());
  }
}
