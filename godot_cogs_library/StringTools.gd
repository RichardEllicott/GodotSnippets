"""

my string functions

"""

class_name StringTools


## take an integer and output a string with comma seperators (1000000 -> 1,000,000)
static func int_to_comma_seperated_string(n: int, sep : String = ",") -> String:
    
    var template_string = sep + "%03d%s"
    
    var result := ""
    var i: int = abs(n)

    while i > 999:
        result = template_string % [i % 1000, result]
        i /= 1000

    return "%s%s%s" % ["-" if n < 0 else "", i, result]     
    
    
    
