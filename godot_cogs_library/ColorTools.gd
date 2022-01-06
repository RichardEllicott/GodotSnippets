class_name ColorTools

##
## ColorTools part of my Godot Cogs Library
##
## @desc:
##     The description of the script, what it
##     can do, and any further detail.
##
## @tutorial:            https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript_documentation_comments.html
## @tutorial(Tutorial2): http://the/tutorial2/url.com
##

"""

NEW

"""

# https://stackoverflow.com/questions/21977786/star-b-v-color-index-to-apparent-rgb-color
static func star_blue_value_to_rgb(bv: float) -> Color:
    var t
    var r
    var g
    var b

    if bv < -0.4: bv = -0.4
    if bv > 2.0: bv = 2.0
    if bv >= -0.40 and bv < 0.00:
        t = (bv + 0.40) / (0.00 + 0.40)
        r = 0.61 + 0.11 * t + 0.1 * t * t
        g = 0.70 + 0.07 * t + 0.1 * t * t
        b = 1.0
    elif bv >= 0.00 and bv < 0.40:
        t = (bv - 0.00) / (0.40 - 0.00)
        r = 0.83 + (0.17 * t)
        g = 0.87 + (0.11 * t)
        b = 1.0
    elif bv >= 0.40 and bv < 1.60:
        t = (bv - 0.40) / (1.60 - 0.40)
        r = 1.0
        g = 0.98 - 0.16 * t
    else:
        t = (bv - 1.60) / (2.00 - 1.60)
        r = 1.0
        g = 0.82 - 0.5 * t * t
    if bv >= 0.40 and bv < 1.50:
        t = (bv - 0.40) / (1.50 - 0.40)
        b = 1.00 - 0.47 * t + 0.1 * t * t
    elif bv >= 1.50 and bv < 1.951:
        t = (bv - 1.50) / (1.94 - 1.50)
        b = 0.63 - 0.6 * t * t
    else:
        b = 0.0
    return Color(r, g, b)

# Note all my HSV functions are useless as Color supports (r g b) and also (h s v)

# also the Color object can be multiplied together:
#   Color(0.5,1,0) * Color(0.5,0.5,0) => Color(0.25,0.5,0)

    
