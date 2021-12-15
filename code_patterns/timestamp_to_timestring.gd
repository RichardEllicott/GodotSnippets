"""

timestamp_to_timestring

0 => 1970/01/01 00:00


60*60*24*88    # 88 days
=>
1970/03/30 00:00





"""



func timestamp_to_timestring(number) -> String:
    var time : Dictionary = OS.get_datetime_from_unix_time(number);
    var display_string : String = "%d/%02d/%02d %02d:%02d" % [time.year, time.month, time.day, time.hour, time.minute];
    return display_string
