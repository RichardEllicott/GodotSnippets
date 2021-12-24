"""

for making numbers like:

6709300 -> 6,709,300


modified from https://godotengine.org/qa/18559/how-to-add-commas-to-an-integer-or-float-in-gdscript

"""


## take an integer and output a string with comma seperators (1000000 -> 1,000,000)
static func comma_sep(n: int, sep : String = ",") -> String:
    
    var template_string = sep + "%03d%s"
    
    var result := ""
    var i: int = abs(n)

    while i > 999:
        result = template_string % [i % 1000, result]
        i /= 1000

    return "%s%s%s" % ["-" if n < 0 else "", i, result]     
