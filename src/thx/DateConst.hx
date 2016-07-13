package thx;

class DateConst {
  public inline static var millisPerSecond : Float = 1000;
  public inline static var millisPerMinute : Float = millisPerSecond * 60;
  public inline static var millisPerHour : Float = millisPerMinute * 60;
  public inline static var millisPerDay : Float = millisPerHour * 24;

  public inline static var daysPerYear : Int = 365;
  public inline static var daysPer4Years : Int = daysPerYear * 4 + 1;       // 1461
  public inline static var daysPer100Years : Int = daysPer4Years * 25 - 1;  // 36524
  public inline static var daysPer400Years : Int = daysPer100Years * 4 + 1; // 146097

  public inline static var unixEpochDays : Int = daysPer400Years * 4 + daysPer100Years * 3 + daysPer4Years * 17 + daysPerYear; // 719,162

  public static var daysToMonth365 = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];
  public static var daysToMonth366 = [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366];
}
