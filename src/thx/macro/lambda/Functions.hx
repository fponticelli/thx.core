package thx.macro.lambda;

#if macro
  import thx.macro.Macros;
  import thx.macro.lambda.MacroHelper;
  import haxe.macro.Context;
  import haxe.macro.Expr;
  using haxe.macro.ExprTools;
  using StringTools;
  import thx.macro.lambda.MacroHelper.*;
#end


class Functions {
  macro public static function fn(filter:Expr) {
    var new_filter = filter.map(replace_());
    return macro function(__tmp1) { return $new_filter;  };
  }

  macro public static function fn0(filter:Expr) return macro function() { return $filter;  };

  macro public static function fn1(filter:Expr) {
    var new_filter = filter.map(replace1());
    return macro function(__tmp1) { return $new_filter;  };
  }


  macro public static function fn2(filter:Expr) {
    var new_filter = filter.map(replace1()).map(replace2());
    return macro function(__tmp1,__tmp2) { return $new_filter;  };
  }

  macro public static function fn3(filter:Expr) {
    var new_filter = filter.map(replace1()).map(replace2()).map(replace3());
    return macro function(__tmp1,__tmp2,__tmp3) { return $new_filter;  };
  }

  macro public static function fn4(filter:Expr) {
    var new_filter = filter.map(replace1()).map(replace2()).map(replace3()).map(replace4());
    return macro function(__tmp1,__tmp2,__tmp3,__tmp4) { return $new_filter;  };
  }

  macro public static function fn5(filter:Expr) {
    var new_filter = filter.map(replace1()).map(replace2()).map(replace3()).map(replace4()).map(replace5());
    return macro function(__tmp1,__tmp2,__tmp3,__tmp4,__tmp5) { return $new_filter;  };
  }

}
