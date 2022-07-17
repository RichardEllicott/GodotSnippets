
## convert a unix time number to a readable string
## built to display a time to the user like 03/06/2017 13:01:44
static func unix_time_to_timestamp(number) -> String:
    var time : Dictionary = OS.get_datetime_from_unix_time(number);
#    var display_string : String = "%d/%02d/%02d %02d:%02d" % [time.year, time.month, time.day, time.hour, time.minute];
    var display_string : String = "%d/%02d/%02d %02d:%02d:%02d" % [time.day, time.month, time.year, time.hour, time.minute, time.second];
    return display_string
    

## get a unix time from setting the year/month/day...
# built to make it easy to construct a made up future time in unix time, like the 31st century or something
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
