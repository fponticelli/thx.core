/**
 * ...
 * @author Franco Ponticelli
 */

package thx.core;

abstract Procedure<T>({ f : T, arity : Int })
{
	inline function new(f : T, arity : Int) 
		this = { f : f, arity : arity };
	
	@:from static public inline function fromArity0(f : Void -> Void)
		return new Procedure(f, 0);
	
	@:from static public inline function fromArity1<T1>(f : T1 -> Void)
		return new Procedure(f, 1);
	
	@:from static public inline function fromArity2<T1, T2>(f : T1 -> T2 -> Void)
		return new Procedure(f, 2);
	
	@:from static public inline function fromArity3<T1, T2, T3>(f : T1 -> T2 -> T3 -> Void)
		return new Procedure(f, 3);
	
	@:from static public inline function fromArity4<T1, T2, T3, T4>(f : T1 -> T2 -> T3 -> T4 -> Void)
		return new Procedure(f, 4);
	
	@:from static public inline function fromArity5<T1, T2, T3, T4, T5>(f : T1 -> T2 -> T3 -> T4 -> T5 -> Void)
		return new Procedure(f, 5);
	@:to public inline function toArity0() : Void -> Void
	{
		if(this.arity != 0)
			throw 'this procedure has arity ${this.arity} but you are trying to use it with arity 0';
		return cast this.f;
	}
	
	@:to public inline function toArity1<T1>() : T1 -> Void
	{
		if(this.arity != 1)
			throw 'this procedure has arity ${this.arity} but you are trying to use it with arity 1';
		return cast this.f;
	}
	
	@:to public inline function toArity2<T1, T2>() : T1 -> T2 -> Void
	{
		if(this.arity != 2)
			throw 'this procedure has arity ${this.arity} but you are trying to use it with arity 2';
		return cast this.f;
	}
	
	@:to public inline function toArity3<T1, T2, T3>() : T1 -> T2 -> T3 -> Void
	{
		if(this.arity != 3)
			throw 'this procedure has arity ${this.arity} but you are trying to use it with arity 3';
		return cast this.f;
	}
	
	@:to public inline function toArity4<T1, T2, T3, T4>() : T1 -> T2 -> T3 -> T4 -> Void
	{
		if(this.arity != 4)
			throw 'this procedure has arity ${this.arity} but you are trying to use it with arity 4';
		return cast this.f;
	}
	
	@:to public inline function toArity5<T1, T2, T3, T4, T5>() : T1 -> T2 -> T3 -> T4 -> T5 -> Void
	{
		if(this.arity != 5)
			throw 'this procedure has arity ${this.arity} but you are trying to use it with arity 5';
		return cast this.f;
	}

	public inline function getArity() : Int
		return this.arity;
		
	public inline function getFunction() : T
		return this.f;
		
	public inline function apply(args : Array<Dynamic>)
	{
		if (args.length != this.arity)
			throw 'invalid number of arguments, expected ${this.arity} but was ${args.length}';
		Reflect.callMethod(null, this.f, args);
	}
}