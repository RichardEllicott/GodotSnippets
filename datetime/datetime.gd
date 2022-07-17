
## convert a unix time number to a readable string
static func unix_time_to_timestamp(number) -> String:
    var time : Dictionary = OS.get_datetime_from_unix_time(number);
#    var display_string : String = "%d/%02d/%02d %02d:%02d" % [time.year, time.month, time.day, time.hour, time.minute];
    var display_string : String = "%d/%02d/%02d %02d:%02d:%02d" % [time.day, time.month, time.year, time.hour, time.minute, time.second];
    return display_string
    

## get a unix time from setting the year/month/day...
static func unix_time_from_year(year = 2000, month = 1, day = 1, hour = 0, minute = 0, second = 0):
    
    var ret = OS.get_unix_time_from_datetime({
        'year' : year,
        'month' : month,
        'day' : day,
        'hour' : hour,
        'minute' : minute,
        'second' : second
        })
        
    return ret
