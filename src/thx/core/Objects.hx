package thx.core;

class Objects {
	inline public static function isEmpty(o : {})
		return Reflect.fields(o).length == 0;
}
