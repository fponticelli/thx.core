package thx.core;

abstract Tuple2<{ e0 : T0, e1 : T1 }> {
	inline public function new(e0 : T0, e1 : T1)
		this = { e0 : e0, e1 : e1 };
	public var e0(get, null) : T0;
	public var e1(get, null) : T1;
	function get_e0() return this.e0;
	function get_e1() return this.e1;

	public inline function toString()
		return 'Tuple2($e0,$e1)';
}

abstract Tuple3<{ e0 : T0, e1 : T1, e2 : T2 }> {
	inline public function new(e0 : T0, e1 : T1, e2 : T2)
		this = { e0 : e0, e1 : e1, e2 : e2 };
	public var e0(get, null) : T0;
	public var e1(get, null) : T1;
	public var e2(get, null) : T2;
	function get_e0() return this.e0;
	function get_e1() return this.e1;
	function get_e2() return this.e2;

	public inline function toString()
		return 'Tuple3($e0,$e1,$e2)';
}

abstract Tuple4<{ e0 : T0, e1 : T1, e2 : T2, e3 : T3 }> {
	inline public function new(e0 : T0, e1 : T1, e2 : T2, e3 : T3)
		this = { e0 : e0, e1 : e1, e2 : e2, e3 : e3 };
	public var e0(get, null) : T0;
	public var e1(get, null) : T1;
	public var e2(get, null) : T2;
	public var e3(get, null) : T3;
	function get_e0() return this.e0;
	function get_e1() return this.e1;
	function get_e2() return this.e2;
	function get_e3() return this.e3;

	public inline function toString()
		return 'Tuple4($e0,$e1,$e2,$e3)';
}

abstract Tuple5<{ e0 : T0, e1 : T1, e2 : T2, e3 : T3, e4 : T4 }> {
	inline public function new(e0 : T0, e1 : T1, e2 : T2, e3 : T3, e4 : T4)
		this = { e0 : e0, e1 : e1, e2 : e2, e3 : e3, e4 : e4 };
	public var e0(get, null) : T0;
	public var e1(get, null) : T1;
	public var e2(get, null) : T2;
	public var e3(get, null) : T3;
	public var e4(get, null) : T4;
	function get_e0() return this.e0;
	function get_e1() return this.e1;
	function get_e2() return this.e2;
	function get_e3() return this.e3;
	function get_e4() return this.e4;

	public inline function toString()
		return 'Tuple5($e0,$e1,$e2,$e3,$e4)';
}

abstract Tuple6<{ e0 : T0, e1 : T1, e2 : T2, e3 : T3, e4 : T4, e5 : T5 }> {
	inline public function new(e0 : T0, e1 : T1, e2 : T2, e3 : T3, e4 : T4, e5 : T5)
		this = { e0 : e0, e1 : e1, e2 : e2, e3 : e3, e4 : e4, e5 : e5 };
	public var e0(get, null) : T0;
	public var e1(get, null) : T1;
	public var e2(get, null) : T2;
	public var e3(get, null) : T3;
	public var e4(get, null) : T4;
	public var e5(get, null) : T5;
	function get_e0() return this.e0;
	function get_e1() return this.e1;
	function get_e2() return this.e2;
	function get_e3() return this.e3;
	function get_e4() return this.e4;
	function get_e5() return this.e5;

	public inline function toString()
		return 'Tuple6($e0,$e1,$e2,$e3,$e4,$e5)';
}