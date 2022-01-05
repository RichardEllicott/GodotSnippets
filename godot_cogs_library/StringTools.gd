class_name StringTools

##
## SphereTools part of my Godot Cogs Library
##
## @desc:
##     The description of the script, what it
##     can do, and any further detail.
##
## @tutorial:            https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript_documentation_comments.html
## @tutorial(Tutorial2): http://the/tutorial2/url.com
##


# https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript_documentation_comments.html#documenting-script-members


## take an integer and output a string with comma seperators (1000000 -> 1,000,000)
static func int_to_comma_seperated_string(n: int, sep : String = ",") -> String:
    
    var template_string = sep + "%03d%s"
    
    var result := ""
    var i: int = abs(n)

    while i > 999:
        result = template_string % [i % 1000, result]
        i /= 1000

    return "%s%s%s" % ["-" if n < 0 else "", i, result]     
    
    
    
