package thx;

class DateHelper {
  macro public static function nowUtc() {
    var date = DateTimeUtc.now().toString();
    return macro thx.DateTimeUtc.fromString($v{date});
  }

  macro public static function now() {
    var date = DateTime.now().toString();
    return macro thx.DateTime.fromString($v{date});
  }

  macro public static function localOffset() {
    var offset = DateTime.localOffset().toString();
    return macro thx.Time.fromString($v{offset});
  }
}
