package thx.core;

abstract Tuple2<T0, T1>({ e0 : T0, e1 : T1 }) {
	inline public function new(e0 : T0, e1 : T1)
		this = { e0 : e0, e1 : e1 };
	public var e0(get, never) : T0;
	public var e1(get, never) : T1;
	function get_e0() return this.e0;
	function get_e1() return this.e1;

	public inline function toString()
		return 'Tuple2($e0,$e1)';
}

abstract Tuple3<T0, T1, T2>({ e0 : T0, e1 : T1, e2 : T2 }) {
	inline public function new(e0 : T0, e1 : T1, e2 : T2)
		this = { e0 : e0, e1 : e1, e2 : e2 };
	public var e0(get, never) : T0;
	public var e1(get, never) : T1;
	public var e2(get, never) : T2;
	function get_e0() return this.e0;
	function get_e1() return this.e1;
	function get_e2() return this.e2;

	public inline function toString()
		return 'Tuple3($e0,$e1,$e2)';
}

abstract Tuple4<T0, T1, T2, T3>({ e0 : T0, e1 : T1, e2 : T2, e3 : T3 }) {
	inline public function new(e0 : T0, e1 : T1, e2 : T2, e3 : T3)
		this = { e0 : e0, e1 : e1, e2 : e2, e3 : e3 };
	public var e0(get, never) : T0;
	public var e1(get, never) : T1;
	public var e2(get, never) : T2;
	public var e3(get, never) : T3;
	function get_e0() return this.e0;
	function get_e1() return this.e1;
	function get_e2() return this.e2;
	function get_e3() return this.e3;

	public inline function toString()
		return 'Tuple4($e0,$e1,$e2,$e3)';
}

abstract Tuple5<T0, T1, T2, T3, T4>({ e0 : T0, e1 : T1, e2 : T2, e3 : T3, e4 : T4 }) {
	inline public function new(e0 : T0, e1 : T1, e2 : T2, e3 : T3, e4 : T4)
		this = { e0 : e0, e1 : e1, e2 : e2, e3 : e3, e4 : e4 };
	public var e0(get, never) : T0;
	public var e1(get, never) : T1;
	public var e2(get, never) : T2;
	public var e3(get, never) : T3;
	public var e4(get, never) : T4;
	function get_e0() return this.e0;
	function get_e1() return this.e1;
	function get_e2() return this.e2;
	function get_e3() return this.e3;
	function get_e4() return this.e4;

	public inline function toString()
		return 'Tuple5($e0,$e1,$e2,$e3,$e4)';
}

abstract Tuple6<T0, T1, T2, T3, T4, T5>({ e0 : T0, e1 : T1, e2 : T2, e3 : T3, e4 : T4, e5 : T5 }) {
	inline public function new(e0 : T0, e1 : T1, e2 : T2, e3 : T3, e4 : T4, e5 : T5)
		this = { e0 : e0, e1 : e1, e2 : e2, e3 : e3, e4 : e4, e5 : e5 };
	public var e0(get, never) : T0;
	public var e1(get, never) : T1;
	public var e2(get, never) : T2;
	public var e3(get, never) : T3;
	public var e4(get, never) : T4;
	public var e5(get, never) : T5;
	function get_e0() return this.e0;
	function get_e1() return this.e1;
	function get_e2() return this.e2;
	function get_e3() return this.e3;
	function get_e4() return this.e4;
	function get_e5() return this.e5;

	public inline function toString()
		return 'Tuple6($e0,$e1,$e2,$e3,$e4,$e5)';
}