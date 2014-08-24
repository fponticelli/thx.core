package thx.core;

abstract Tuple1<T0>(T0) {
	inline public function new(_0 : T0)
		this = _0;
	public var _0(get, never) : T);
	inline function get__0() return this;

	public inline function toString()
		return 'Tuple2($_0,$_1)';
}

abstract Tuple2<T0, T1>({ _0 : T0, _1 : T1 }) {
	inline public function new(_0 : T0, _1 : T1)
		this = { _0 : _0, _1 : _1 };
	public var _0(get, never) : T0;
	public var _1(get, never) : T1;
	inline function get__0() return this._0;
	inline function get__1() return this._1;

	public inline function toString()
		return 'Tuple2($_0,$_1)';
}

abstract Tuple3<T0, T1, T2>({ _0 : T0, _1 : T1, _2 : T2 }) {
	inline public function new(_0 : T0, _1 : T1, _2 : T2)
		this = { _0 : _0, _1 : _1, _2 : _2 };
	public var _0(get, never) : T0;
	public var _1(get, never) : T1;
	public var _2(get, never) : T2;
	inline function get__0() return this._0;
	inline function get__1() return this._1;
	inline function get__2() return this._2;

	public inline function toString()
		return 'Tuple3($_0,$_1,$_2)';
}

abstract Tuple4<T0, T1, T2, T3>({ _0 : T0, _1 : T1, _2 : T2, _3 : T3 }) {
	inline public function new(_0 : T0, _1 : T1, _2 : T2, _3 : T3)
		this = { _0 : _0, _1 : _1, _2 : _2, _3 : _3 };
	public var _0(get, never) : T0;
	public var _1(get, never) : T1;
	public var _2(get, never) : T2;
	public var _3(get, never) : T3;
	inline function get__0() return this._0;
	inline function get__1() return this._1;
	inline function get__2() return this._2;
	inline function get__3() return this._3;

	public inline function toString()
		return 'Tuple4($_0,$_1,$_2,$_3)';
}

abstract Tuple5<T0, T1, T2, T3, T4>({ _0 : T0, _1 : T1, _2 : T2, _3 : T3, _4 : T4 }) {
	inline public function new(_0 : T0, _1 : T1, _2 : T2, _3 : T3, _4 : T4)
		this = { _0 : _0, _1 : _1, _2 : _2, _3 : _3, _4 : _4 };
	public var _0(get, never) : T0;
	public var _1(get, never) : T1;
	public var _2(get, never) : T2;
	public var _3(get, never) : T3;
	public var _4(get, never) : T4;
	inline function get__0() return this._0;
	inline function get__1() return this._1;
	inline function get__2() return this._2;
	inline function get__3() return this._3;
	inline function get__4() return this._4;

	public inline function toString()
		return 'Tuple5($_0,$_1,$_2,$_3,$_4)';
}

abstract Tuple6<T0, T1, T2, T3, T4, T5>({ _0 : T0, _1 : T1, _2 : T2, _3 : T3, _4 : T4, _5 : T5 }) {
	inline public function new(_0 : T0, _1 : T1, _2 : T2, _3 : T3, _4 : T4, _5 : T5)
		this = { _0 : _0, _1 : _1, _2 : _2, _3 : _3, _4 : _4, _5 : _5 };
	public var _0(get, never) : T0;
	public var _1(get, never) : T1;
	public var _2(get, never) : T2;
	public var _3(get, never) : T3;
	public var _4(get, never) : T4;
	public var _5(get, never) : T5;
	inline function get__0() return this._0;
	inline function get__1() return this._1;
	inline function get__2() return this._2;
	inline function get__3() return this._3;
	inline function get__4() return this._4;
	inline function get__5() return this._5;

	public inline function toString()
		return 'Tuple6($_0,$_1,$_2,$_3,$_4,$_5)';
}