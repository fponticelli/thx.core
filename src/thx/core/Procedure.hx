/**
 * ...
 * @author Franco Ponticelli
 */

package thx.core;

abstract ProcedureDef<T>(T)
{
	inline function new(fun : T) 
		this = fun;

	@:from static public inline function fromArity0(fun : Void -> Void)
		return new ProcedureDef(fun);
	
	@:from static public inline function fromArity1<T1>(fun : T1 -> Void)
		return new ProcedureDef(fun);
	
	@:from static public inline function fromArity2<T1, T2>(fun : T1 -> T2 -> Void)
		return new ProcedureDef(fun);
	
	@:from static public inline function fromArity3<T1, T2, T3>(fun : T1 -> T2 -> T3 -> Void)
		return new ProcedureDef(fun);
	
	@:from static public inline function fromArity4<T1, T2, T3, T4>(fun : T1 -> T2 -> T3 -> T4 -> Void)
		return new ProcedureDef(fun);
	
	@:from static public inline function fromArity5<T1, T2, T3, T4, T5>(fun : T1 -> T2 -> T3 -> T4 -> T5 -> Void)
		return new ProcedureDef(fun);

	public inline function getFunction() : T
		return this;
		
	public inline function apply(args : Array<Dynamic>)
		Reflect.callMethod(null, this, args);
	
	@:op(A == B) public inline function equal(other : ProcedureDef<T>)
	{
		return Reflect.compareMethods(this, other.getFunction());
	}
}

abstract Procedure<T>({ fun : T, arity : Int })
{
	public inline function new(fun : ProcedureDef<T>, arity : Int) 
		this = { fun : fun.getFunction(), arity : arity };
	
	@:from static public inline function fromArity0(fun : Void -> Void)
		return new Procedure(fun, 0);
	
	@:from static public inline function fromArity1<T1>(fun : T1 -> Void)
		return new Procedure(fun, 1);
	
	@:from static public inline function fromArity2<T1, T2>(fun : T1 -> T2 -> Void)
		return new Procedure(fun, 2);
	
	@:from static public inline function fromArity3<T1, T2, T3>(fun : T1 -> T2 -> T3 -> Void)
		return new Procedure(fun, 3);
	
	@:from static public inline function fromArity4<T1, T2, T3, T4>(fun : T1 -> T2 -> T3 -> T4 -> Void)
		return new Procedure(fun, 4);
	
	@:from static public inline function fromArity5<T1, T2, T3, T4, T5>(fun : T1 -> T2 -> T3 -> T4 -> T5 -> Void)
		return new Procedure(fun, 5);
	@:to public inline function toArity0() : Void -> Void
	{
		if(this.arity != 0)
			throw 'this procedure has arity ${this.arity} but you are trying to use it with arity 0';
		return cast this.fun;
	}
	
	@:to public inline function toArity1<T1>() : T1 -> Void
	{
		if(this.arity != 1)
			throw 'this procedure has arity ${this.arity} but you are trying to use it with arity 1';
		return cast this.fun;
	}
	
	@:to public inline function toArity2<T1, T2>() : T1 -> T2 -> Void
	{
		if(this.arity != 2)
			throw 'this procedure has arity ${this.arity} but you are trying to use it with arity 2';
		return cast this.fun;
	}
	
	@:to public inline function toArity3<T1, T2, T3>() : T1 -> T2 -> T3 -> Void
	{
		if(this.arity != 3)
			throw 'this procedure has arity ${this.arity} but you are trying to use it with arity 3';
		return cast this.fun;
	}
	
	@:to public inline function toArity4<T1, T2, T3, T4>() : T1 -> T2 -> T3 -> T4 -> Void
	{
		if(this.arity != 4)
			throw 'this procedure has arity ${this.arity} but you are trying to use it with arity 4';
		return cast this.fun;
	}
	
	@:to public inline function toArity5<T1, T2, T3, T4, T5>() : T1 -> T2 -> T3 -> T4 -> T5 -> Void
	{
		if(this.arity != 5)
			throw 'this procedure has arity ${this.arity} but you are trying to use it with arity 5';
		return cast this.fun;
	}

	public inline function getArity() : Int
		return this.arity;
		
	public inline function getFunction() : T
		return this.fun;
		
	public inline function apply(args : Array<Dynamic>)
	{
		if (args.length != this.arity)
			throw 'invalid number of arguments, expected ${this.arity} but was ${args.length}';
		Reflect.callMethod(null, this.fun, args);
	}
	
	@:op(A == B) public inline function equal(other : Procedure<T>)
	{
		return Reflect.compareMethods(this.fun, other.getFunction());
	}
}