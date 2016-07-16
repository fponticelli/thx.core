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

private typedef GeneratorResult<T>  = Tuple2<Option<T>,Generator<T>>;
private typedef Generator<T>        = Void-> GeneratorResult<T>;

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
  /*
  public function visit(){
    return new TreeVisitor(this);
  }*/
}
class Trees{

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
