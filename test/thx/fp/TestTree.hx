package thx.fp;

import utest.Assert;
import thx.fp.List;
import thx.fp.KTree;
import thx.fp.ktree.Zipper;

@:access(thx.fp) class TestTree {
  public function new() {}
  function construct():KTree<String> {
    return Branch(
      'root',
      [Branch('l',[Branch('ll'),Branch("lr")]),Branch('m',[Branch('ml'),Branch('mm'),Branch('mr')]),Branch('r')]
    );
  }
  public function testSelectDF(){
    var t : Zipper<String> = construct();
    var a =  t.selectDF(function(x) return x =='mr');
    var b = t.down().right().down().right();
    Assert.isTrue(a.toTree().equals(b.toTree()));
  }
  public function testZipNavigation(){
    var t : Zipper<String> = construct();
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
    var t : Zipper<String> = construct();
    var leaf = t.down().down();
    var folded = leaf.foldLeft(
      List.empty(),
      function(memo,next){
        return Cons(next,memo);
      }
    );
    var updated = leaf.update(Branch("w00t"));
    Assert.equals('w00t',updated.up().down().value());
    Assert.equals('w00t',updated.up().up().down().down().value());
    Assert.equals('l',updated.up().value());
    Assert.equals('root',updated.up().up().value());
  }
  public function testZipMod(){
    var t : Zipper<String> = construct();
    var l   = t.down();
    var ll  = l.down();
    var without_ll = l.remChildNode(ll.head());
    Assert.equals('lr',without_ll.up().down().down().value());
    var add_ll = without_ll.addChildNode(ll.head());
    Assert.equals('ll',add_ll.up().down().down().value());
  }
  public function testLeftRight(){
    var t = construct().zipper();
    var l = t.down();
    Assert.equals('l',l.value());
    var m = l.right();
    Assert.equals('m',m.value());
    var r = m.right();
    Assert.equals('r',r.value());
    var m = r.left();
    Assert.equals('m',m.value());
    var l = m.left();
    Assert.equals('l',l.value());
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
}
