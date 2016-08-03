package thx.fp;

import Map;

import thx.fp.ktree.Zipper;
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

/**
  Untagged immutable Kary Tree. use .zipper to navigate and edit stepwise.
*/
abstract KTree<T>(KTreeImpl<T>) from KTreeImpl<T>{
  @:noUsing inline static public function empty<A>() : KTree<A>{
    return Empty;
  }
  public function df(){
    return KTrees.iterDF(this);
  }
  public function bf(){
    return KTrees.iterBF(this);
  }
  public function zipper():Zipper<T>{
    return new Zipper(Cons(this,List.empty()));
  }
}
class KTrees{

  static function nothing<T>():GeneratorResult<T>{
    return new Tuple2(None,nothing);
  }
  static function next<T>(t:List<KTree<T>>,concat:List<KTree<T>> -> List<KTree<T>> -> List<KTree<T>>):GeneratorResult<T>{
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
  static function df_concat<T>(l:List<KTree<T>>,r:List<KTree<T>>):List<KTree<T>>{
    return l.concat(r);
  }
  static function bf_concat<T>(l:List<KTree<T>>,r:List<KTree<T>>):List<KTree<T>>{
    return r.concat(l);
  }
  static public function genDF<T>(node:KTree<T>){
    var vals : List<KTree<T>> = Cons(node,Nil);
    return next.bind(vals,df_concat);
  }
  /**
    Creates a depth first iterable from a KTree.
  */
  static public function iterDF<T>(node:KTree<T>): Iterable<T> return iter(genDF(node));
  static public function genBF<T>(node:KTree<T>){
    var vals : List<KTree<T>> = Cons(node,Nil);
    return next.bind(vals,bf_concat);
  }
  /**
    Creates a breadth first iterable from a KTree.
  */
  static public function iterBF<T>(node:KTree<T>):Iterable<T> return iter(genBF(node));
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
enum KTreeImpl<T>{
 Empty;
 Branch(x:T,?xs:List<KTree<T>>);
}
