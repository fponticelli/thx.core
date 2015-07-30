package thx;

class DateHelper {
  macro public static function now() {
    var date = DateTimeUtc.now().toString();
    return macro thx.DateTimeUtc.fromString($v{date});
  }
}
