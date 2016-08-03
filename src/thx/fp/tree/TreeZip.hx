package thx.fp.tree;

using thx.Iterables;
using thx.Tuple;
import haxe.ds.Option;

import thx.fp.List;
import thx.fp.Tree;

/**
  Holds a path from the root to allow Tree navigation and
  immutable editing.
  of the form [root,[down,down],current]
*/
@:forward abstract TreeZip<T>(List<Tree<T>>) from List<Tree<T>>{
  public function new(self){
    this = self;
  }
  @:from static public function fromTree<T>(v:Tree<T>):TreeZip<T>{
    return new TreeZip(Cons(v,Nil));
  }
  public function isRoot():Bool{
    return switch this {
      case Cons(x,Nil) : true;
      default : false;
    }
  }
  public function end():TreeZip<T>{
    return Cons(Tree.empty(),this);
  }
  public function right():TreeZip<T>{
    return switch this {
      case Cons(cursor,Cons(Branch(v,siblings),previous)):
        switch(findHead(siblings,cursor)){
          case Cons(_,Cons(right,_))  :
            var tree : Tree<T> = Branch(v,siblings);
            var o : TreeZip<T> = new TreeZip(Cons(right,Cons(tree,previous)));
            return o;
          default                     :
            var tree : Tree<T> = Branch(v,siblings);
            Cons(Tree.empty(),Cons(tree,previous));
        }
      default : end();
    }
  }
  public function left():TreeZip<T>{
    return switch(this){
      case Cons(cursor,Cons(Branch(v,siblings),previous)):
        switch(findLeft(siblings,cursor)){
          case Cons(left,_) :
            var tree : Tree<T> = Branch(v,siblings);
            Cons(left,Cons(tree,previous));
          default :
            var tree : Tree<T> = Branch(v,siblings);
            Cons(Tree.empty(),Cons(tree,previous));
        }
      default : Cons(Tree.empty(),this);
    }
  }
  public function up():TreeZip<T>{
    var o : TreeZip<T> = switch(this){
      case Cons(cursor,Cons(parent,rest)) : Cons(parent,rest);
      default                             : this;
    }
    return o;
  }
  /**
    Select the first child of the node at cursor.
  */
  public function down():TreeZip<T>{
    return switch this {
      case Cons(Branch(_,Cons(firstChild,_)),_): Cons(firstChild,this);
      default: Cons(Tree.empty(),this);
    }

  }
  /*
    Produces the value of the head node.
  */
  public function value(){
    return switch(this){
      case Cons(Branch(v,_),_): v;
      default : null;
    }
  }
  /**
    Resets navigation.
  */
  public function root():TreeZip<T>{
    return Cons(this.last(),Nil);
  }
  /**
    Produces the Tree
  */
  public function toTree():Tree<T>{
    return this.last();
  }
  /*
    Updates the currently focused node.
  */
  public static function update<T>(zip:TreeZip<T>,replace:Tree<T>):TreeZip<T>{
    var changes : List<Tuple2<Tree<T>,Tree<T>>> = zip.foldLeft(Nil,
      function(memo:List<Tuple2<Tree<T>,Tree<T>>>,next:Tree<T>):List<Tuple2<Tree<T>,Tree<T>>>{
        return switch([memo,next]){
          case [Nil,_]:
            var ls : List<Tuple2<Tree<T>,Tree<T>>> = Cons(new Tuple2(next,replace),Nil);
            ls;
          case [memo,Branch(v,rst)]:
            rst = (rst == null) ? List.empty() : rst;
            var leaves : List<Tree<T>> = rst.map(
                function(x:Tree<T>):Tree<T>{
                  var shouldChange = x == memo.head()._0;
                  return shouldChange ? memo.head()._1 : x;
                }
              );
            var branch : Tree<T>  = Branch(v,leaves);
            var o : List<Tuple2<Tree<T>,Tree<T>>> = Cons(new Tuple2(next,branch),memo);
            o;
          case [_,Empty] :
            memo;
        }
      }
    );
    function handler(next:List<Tuple2<Tree<T>,Tree<T>>>):List<Tree<T>>{
      return switch(next){
        case Cons(x,xs) :
          var ls = handler(xs);
          ls.concat(Cons(x._1,Nil));
        default : Nil;
      }
    }
    var o = handler(changes);
    return new TreeZip(o);
  }
  /**
    Adds a child value as a leaf to the selected node.
  */
  public function addChild(v:T):TreeZip<T>{
    var new_tree : Tree<T> = Branch(v,List.empty());
    return addChildNode(new_tree);
  }
  /**
    Adds a child value to the selected node.
  */
  public function addChildNode(v:Tree<T>):TreeZip<T>{
    return switch(this){
      case Cons(Branch(node,children),rest) :
        var new_node = Branch(node,children.prepend(v));
        update(this,new_node);
      default : Cons(v,List.empty());
    }
  }
  /**
    Removes a child node by identity.
  */
  public function remChildNode(v:Tree<T>):TreeZip<T>{
    return switch(this){
      case Cons(Branch(node,children),rest) if (children == null) : this;
      case Cons(Branch(node,children),rest) :
        children = children.foldLeft(
          List.empty(),
          function(memo,next){
            return switch(next){
              case _  if(treeEquals.bind(v,next)): memo;
              default : Cons(next,memo);
            }
          }
        );
        var new_node = Branch(node,children);
        update(this,new_node);
      default : this;
    }
  }
  /**
    Does a downward breadth first search starting on the selected node
  */
  /*
  function select(fn:T->Bool){
    var handler = function(ls){

    }
  }*/
  function findLeft(list:List<Tree<T>>,cursor:Tree<T>):List<Tree<T>>{
    function handler(ls,c):List<Tree<T>>{
      return switch(ls){
        case Cons(x,Cons(y,ys)) if (treeEquals(c,y)) : Cons(x,ys);
        case Cons(x,xs) : handler(xs,c);
        default : Nil;
      }
    }
    return handler(list,cursor);
  }
  function findHead(list:List<Tree<T>>,cursor:Tree<T>):List<Tree<T>>{
    function handler(ls,c){
      return switch(ls){
        case Cons(x,xs) if (treeEquals(c,x)) : Cons(x,xs);
        case Cons(x,xs) : handler(xs,c);
        default : Nil;
      }
    }
    return handler(list,cursor);
  }
  static function treeEquals<T>(treel:Tree<T>,treer:Tree<T>){
    return treel == treer;
  }
}
