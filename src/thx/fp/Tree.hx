package thx.fp;

import Map;
using thx.Options;
using thx.Eithers;
import thx.Either;
import thx.Assert;

import haxe.ds.Option;
using thx.Tuple;

using thx.Iterables;
using thx.Arrays;
import thx.fp.List;
import thx.Arrays;

using Lambda;

abstract Tree<T>(TreeImpl<T>) from TreeImpl<T>{
  @:noUsing inline static public function empty<A>() : Tree<A>{
    return Empty;
  }
  public function df(){
    return Trees.iterDF(this);
  }
  public function bf(){
    return Trees.iterBF(this);
  }
  public function visit(){
    return new TreeVisitor(this);
  }
}
enum StepT<T>{
  SDown(parent:Tree<T>);
  SRight;
}
abstract Step<T>(StepT<T>) from StepT<T>{
  public function value():Null<Tree<T>>{
    return switch(this){
      case SDown(v) : v;
      default       : null;
    }
  }
}
typedef PathT<T> = ReadonlyArray<Step<T>>;
@:forward abstract Path<T>(PathT<T>) from PathT<T>{
  public inline function new( v : PathT<T> ) {
    this = v;
  }
}
@:allow(thx.fp.Tree)class TreeVisitor<T>{
  var parent  : Tree<T>;
  var cursor  : Tree<T>;
  var path    : Path<T>;
  var level   : List<Tree<T>>;

  public function new(cursor:Tree<T>,?parent,?path,?level){
    this.cursor = cursor;
    this.parent = parent;
    this.path   = path;
    this.level  = level;

    if(parent == null){
      this.parent = cursor;
    }
    if(path == null){
      this.path = [];
    }
    switch([level == null]){
      case [true] : this.level = List.empty();
      default:
    }
  }
  function copy(){
    return new TreeVisitor(cursor,parent,path,level);
  }
  public function value():Null<T>{
    return switch(this.cursor){
      case Branch(x,_)  : x;
      default         : null;
    }
  }
  public function isRoot(){
    return cursor == parent;
  }
  public function withPath(path){
    var next      = copy();
        next.path = path;
    return next;
  }
  public function withCursor(cursor){
    var next = copy();
        next.cursor = cursor;
    return next;
  }
  public function withParent(parent){
    var next = copy();
        next.parent = parent;
    return next;
  }
  public function withLevel(level){
    var next = copy();
        next.level = level;
    return next;
  }
  public function hasRight(){
    var it = this.level.dropUntil(
      function(memo){
        return memo != cursor;
      }
    );
    return it.length > 1;
  }
  public function right(){
    var next_cursor = this.level.dropUntil(
      function(memo){
        return memo != cursor;
      }
    ).tail().head();

    if(next_cursor == null){
      next_cursor = Tree.empty();
    }

    return
      this.withCursor(next_cursor)
          .withPath(path.append(SRight));

  }
  public function hasLeft(){
    return switch(this.level){
      case Cons(x,_)  : !Type.enumEq(cursor,x);
      case Nil        : false;
      case null       : false;
    }
  }
  public function left(){
    return if(hasLeft()){
      var next_cursor = this.level.takeUntil(
        function(memo){
          return memo!=cursor;
        }
      ).last();
      this.withCursor(next_cursor)
          .withPath(path.dropRight(1));
    }else{
      this;
    }
  }
  public function down(){
    var next_cursor = Tree.empty();
    var next_level  = List.empty();
    switch(this.cursor){
      case Branch(x,xs)        :
        next_level = xs;
        switch xs {
          case Cons(y,ys) :
            next_cursor = y;
          default:
        }
      default                :
    }
    Assert.notNull(this.path);

    return
      this.withCursor(next_cursor)
          .withParent(this.cursor)
          .withPath(this.path.append(SDown(cursor)))
          .withLevel(next_level);
  }
  public function up(){
    return if(isRoot()){
      this;
    }else{
      var parents = this.path.reversed().filter(
        function(x:Step<T>){
          return !Type.enumEq(x,SRight);
        }
      );

      var next_cursor = parents[0];
      var next_parent = parents[1];

      var next_path   = this.path.reversed().foldLeft(
        Left([]),
        function(memo,next){
          return switch([memo,next]) {
            case [Left(arr),step] if (!Type.enumEq(step,SRight))  : Right(arr);
            case [Right(arr),step]                                : Right(arr.append(step));
            case [Left(arr),step]                                 : Left(arr);
          }
        }
      ).toRight().getOrElse([]).reversed();

      Assert.notNull(next_cursor);

      this.withCursor(next_cursor.value())
          .withParent(next_parent == null ? null :  next_parent.value())
          .withPath(next_path);
    }
  }
  function update(ls:List<Tree<T>>){
    var next_cursor = switch(this.cursor){
      case Branch(x,xs) : Branch(x,ls);
      default           : Tree.empty();
    }

  }
  public function insert(value:Tree<T>,?after:Tree<T>):TreeVisitor<T>{
    if(after!=null){

    }else{

    }
    return null;
  }
  //public function append
  //public function prepend
}
typedef TreeParentMap<T> = Map<TreeImpl<T>,TreeImpl<T>>;
typedef TreeSemiGroup<T> = List<Tree<T>> -> List<Tree<T>> -> List<Tree<T>>;
private typedef GeneratorResult<T>  = Tuple2<Option<T>,Generator<T>>;
private typedef Generator<T>        = Void-> GeneratorResult<T>;

enum Sign{
  SgLeft;
  SgDown;
}
typedef SignedTreeList<T> = List<Tuple2<Sign,Tree<T>>>;

class Trees{
  static public function tree_sequence<T>(concat:TreeSemiGroup<T>,fn:Tree<T>->Tuple2<Tree<T>,List<Tree<T>>>,tree:Tree<T>){
    var head = fn(tree);

    function handler(cursor:Tree<T>,parent:Tree<T>,rest:List<Tree<T>>){
      var parent_map : TreeParentMap<T> = new Map();
      var next                          = fn(cursor);
      return switch([next._0,next._1]){
        case [changed_node,Cons(head,tail)] :

        default:null;
      }
    }
  }
  static function nothing<T>():GeneratorResult<T>{
    return new Tuple2(None,nothing);
  }
  static function next<T>(t:List<Tree<T>>,concat:List<Tree<T>> -> List<Tree<T>> -> List<Tree<T>>):GeneratorResult<T>{
    return switch t {
      case Cons(Branch(x,xs),rst):
        if(xs == null){ xs = List.empty(); }
        new Tuple2(Some(x),
          next.bind(
            concat(xs,rst),
            concat
          )
        );
      default:
        nothing();
      }
  }
  static function df_concat<T>(l:List<Tree<T>>,r:List<Tree<T>>):List<Tree<T>>{
    return l.concat(r);
  }
  static function bf_concat<T>(l:List<Tree<T>>,r:List<Tree<T>>):List<Tree<T>>{
    return r.concat(l);
  }
  static public function genDF<T>(node:Tree<T>){
    var vals : List<Tree<T>> = Cons(node,Nil);
    return next.bind(vals,df_concat);
  }
  /**
    Creates a depth first iterable from a Tree.
  */
  static public function iterDF(node){ return iter(genDF(node)); }
  static public function genBF<T>(node:Tree<T>){
    var vals : List<Tree<T>> = Cons(node,Nil);
    return next.bind(vals,bf_concat);
  }
  /**
    Creates a breadth first iterable from a Tree.
  */
  static public function iterBF(node){ return iter(genBF(node)); }
  static public function iter<T>(generator:Generator<T>):Iterable<T>{
    return {
      iterator : function(){
        var cursor = generator();
        return {
          next : function(){
            var out = switch(cursor._0){
              case Some(v)  : v;
              default       : null;
            }
            cursor = cursor._1();
            return out;
          },
          hasNext : function(){
            return !Type.enumEq(None,cursor._0);
          }
        }
      }
    };
  }
}
enum TreeImpl<T>{
 Empty;
 Branch(x:T,?xs:List<Tree<T>>);
}
