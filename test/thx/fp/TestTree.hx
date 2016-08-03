package thx.fp;

import utest.Assert;
import thx.fp.List;
import thx.fp.Tree;
import thx.fp.tree.TreeZip;

@:access(thx.fp) class TestTree {
  public function new() {}
  function construct():Tree<String> {
    return Branch(
      'root',
      [Branch('l',[Branch('ll'),Branch("lr")]),Branch('m',[Branch('ml'),Branch('mm'),Branch('mr')]),Branch('r')]
    );
  }
  public function testZipNavigation(){
    var t : TreeZip<String> = construct();
    Assert.isTrue(t.isRoot());
    Assert.equals('root',t.value());
    var l = t.down();
    Assert.equals('l',l.value());
    var m = l.right();
    Assert.equals('m',m.value());
    var root = m.up();
    Assert.equals('root',root.value());
    var l = m.left();
    Assert.equals('l',l.value());
  }
  public function testZipEdit(){
    var t : TreeZip<String> = construct();
    var leaf = t.down().down();
    var folded = leaf.foldLeft(
      List.empty(),
      function(memo,next){
        //trace(next);
        return Cons(next,memo);
      }
    );
    var updated = TreeZip.update(leaf,Branch("w00t"));
    Assert.equals('w00t',updated.up().down().value());
    Assert.equals('w00t',updated.up().up().down().down().value());
    Assert.equals('l',updated.up().value());
    Assert.equals('root',updated.up().up().value());
  }
  public function testZipMod(){
    var t : TreeZip<String> = construct();
    var l   = t.down();
    var ll  = l.down();
    var without_ll = l.remChildNode(ll.head());
    Assert.equals(null,without_ll.up().down().down().value());
    var add_ll = without_ll.addChildNode(ll.head());
    Assert.equals('ll',add_ll.up().down().down().value());
  }

  public function testGen(){
    var tree  = construct();
    var df    = 'rootllllrmmlmmmrr';
    var tdf   = [];
    for ( v in tree.df() ){
      tdf.push(v);
    }
    Assert.equals(df,tdf.join(""));
    var bf    = 'rootlmrlllrmlmmmr';
    var tbf = [];
    for ( v in tree.bf() ){
      tbf.push(v);
    }
    Assert.equals(bf,tbf.join(""));
  }
  /*
  public function testVisitor(){
    var tree    = construct();
    var visitor = tree.visit();
    Assert.equals('root',visitor.value());
    Assert.isFalse(visitor.hasLeft());
    Assert.isFalse(visitor.hasRight());
    Assert.isTrue(visitor.isRoot());


    var l       = visitor.down();
    Assert.equals('l',l.value());
    Assert.isTrue(l.hasRight());
    Assert.isFalse(l.hasLeft());
    Assert.isFalse(l.isRoot());

    var root    = visitor.up();
    Assert.equals('root',root.value());

    var ll      = root.down().down();
    Assert.equals('ll',ll.value());

    var unknown = ll.down();
    Assert.isNull(unknown.value());

    var m       = l.right();
    Assert.equals('m',m.value());
    Assert.isTrue(m.hasRight());
    Assert.isTrue(m.hasLeft());

    var r       = m.right();
    Assert.equals('r',r.value());
    Assert.isFalse(r.hasRight());

    m = r.left();
    Assert.equals('m',m.value());

    trace(m);

    root = m.up();
    Assert.equals('root',root.value());

    Assert.equals(0,root.path.length);

    //trace("________________");
    var mm = root.down().right().down().right();
    Assert.equals('mm',mm.value());


    m    = mm.up();
    Assert.equals(2,m.path.length);
    //trace("________________");
    root = m.up();
    Assert.equals(0,root.path.length);

    m = mm.up();
    trace(m);
    Assert.equals('m',m.value());
  }*/
}
