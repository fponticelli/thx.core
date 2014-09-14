package thx.date;

import thx.core.Strings;

class ISO8601 {
	static var dateParsers = [{
			pattern : ~/^\d{4}$/,
			extract : function(e : EReg) return createDate(mInt(e, 0))
		}, {
			pattern : ~/^(\d{4})-(\d{2})$/,
			extract : function(e : EReg) return createDate(mInt(e, 1), mInt(e, 2))
		}, {
			pattern : ~/^(\d{4})-(\d{2})-(\d{2})$/,
			extract : function(e : EReg) return createDate(mInt(e, 1), mInt(e, 2), mInt(e, 3))
		}, {
			// TODO this pattern is redundant if the "-" becomes optional in the previous pattern
			pattern : ~/^(\d{4})(\d{2})(\d{2})$/,
			extract : function(e : EReg) return createDate(mInt(e, 1), mInt(e, 2), mInt(e, 3))
		}

		// TODO add week parsing (YYYY-Www or YYYYWww/YYYY-Www-D or YYYYWwwD)
		// TODO add ordinal dates parsing (YYYY-DDD or YYYYDDD)
	];
	static var timeZoneSign = ~/([+-])/;
	static var timeParsers = [{
			pattern : ~/^(\d{2}):(\d{2}):(\d{2})$/,
			extract : function(e : EReg) return createTime(mInt(e, 1), mInt(e, 2), mInt(e, 3))
		}, {
			pattern : ~/^(\d{2})(\d{2})(\d{2})$/,
			extract : function(e : EReg) return createTime(mInt(e, 1), mInt(e, 2), mInt(e, 3))
		}, {
			pattern : ~/^(\d{2}):(\d{2})$/,
			extract : function(e : EReg) return createTime(mInt(e, 1), mInt(e, 2))
		}, {
			pattern : ~/^(\d{2})(\d{2})$/,
			extract : function(e : EReg) return createTime(mInt(e, 1), mInt(e, 2))
		}, {
			pattern : ~/^\d{2}$/,
			extract : function(e : EReg) return createTime(mInt(e, 0))
		}
	];
	static function mInt(e : EReg, index : Int)
		return Std.parseInt(e.matched(index));

	public static function parseDate(date : String) : Date {
		for(parser in dateParsers)
			if(parser.pattern.match(date))
				return parser.extract(parser.pattern);
		return throw 'invalid ISO8601 date: $date';
	}

	static function parseOffset(t : String) : ISO8601BaseTime
		return if(t.length == 5)
			{ hour : Std.parseInt(t.substr(0,2)), minute : Std.parseInt(t.substr(3)) };
		else if(t.length == 4)
			{ hour : Std.parseInt(t.substr(0,2)), minute : Std.parseInt(t.substr(2)) };
		else if(t.length == 2)
			{ hour : Std.parseInt(t) };
		else
			throw 'invalid time zone offset: $t';

	public static function parseTime(timeString : String) : ISO8601Time {
		var time     = null,
			timeZone = LocalTime,
			millis   = 0;

		if(timeString.substr(-1) == "Z") {
			timeString = timeString.substr(0, timeString.length-1);
			timeZone	 = UTC;
		} else if(timeZoneSign.match(timeString)) {
			var sign = timeZoneSign.matched(1);
			timeString = timeZoneSign.matchedLeft();
			var offset = parseOffset(timeZoneSign.matchedRight());
			if(sign == "-")
				offset.hour = -offset.hour;
			timeZone = UTCOffset(offset);
		}

		timeString = StringTools.replace(timeString, ",", ".");
		var parts = timeString.split(".");
		if(parts.length == 2) {
			timeString = parts[0];
			millis = Math.round(Std.parseFloat("0." + parts[1]) * 1000);
		}

		for(parser in timeParsers) {
			if(parser.pattern.match(timeString)) {
				time = parser.extract(parser.pattern);
				break;
			}
		}
		if(null != time) {
			time.timeZone = timeZone;
			return time;
		}
		time.millis = millis;
		return throw 'invalid ISO8601 time: $timeString';
	}

	public static function parseDateTime(dateString : String) : Date {
		var parts = dateString.split("T"),
				date	= parseDate(parts[0]);
		if(parts.length == 1) // no time part
			return date;
		else
			return addTimeSpan(date, parseTime(parts[1]));
	}

	// TODO don't ignore time zone
	public static function addTimeSpan(date : Date, span : ISO8601Time)
		return DateTools.delta(date,
			1000 *
			(
				  (null == span.second ? 0 : span.second)
				+ (null == span.minute ? 0 : span.minute) * 60
				+ span.hour * 60 * 60
			)
		);

	static function createDate(year : Int, ?month : Int = 1, ?day : Int = 0, ?hour : Int = 0, ?minute : Int = 0, ?second : Int = 0)
		return new Date(year, month - 1, day, hour, minute, second);

	static function createTime(hour : Int, ?minute : Int, ?second : Int, ?millis : Int, ?timeZone : ISO8601TimeZone) : ISO8601Time {
		if(null == timeZone)
			timeZone = LocalTime;
		if(null == minute)
			return { hour : hour, timeZone : timeZone };
		else if(null == second)
			return { hour : hour, minute : minute, timeZone : timeZone };
		else if(null == millis)
			return { hour : hour, minute : minute, second : second, timeZone : timeZone };
		else
			return { hour : hour, minute : minute, second : second, millis : millis, timeZone : timeZone };
	}
}

typedef ISO8601BaseTime = {
	hour : Int,
	?minute : Int
}

typedef ISO8601Time = {>ISO8601BaseTime,
	?second : Int,
	?millis : Int,
	timeZone : ISO8601TimeZone
}

enum ISO8601TimeZone {
	LocalTime;
	UTC;
	UTCOffset(offset : ISO8601BaseTime);
}