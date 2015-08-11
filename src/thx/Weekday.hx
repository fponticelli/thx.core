package thx;

/**
Named weekdays mapped to integer values from 0 to 6 where 0 is Sunday and 6 is
Saturday.
*/
@:enum
abstract Weekday(Int) from Int to Int {
  var Sunday = 0;
  var Monday = 1;
  var Tuesday = 2;
  var Wednesday = 3;
  var Thursday = 4;
  var Friday = 5;
  var Saturday = 6;
}
