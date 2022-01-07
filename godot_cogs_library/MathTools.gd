class_name MathTools

##
## MathTools part of my Godot Cogs Library
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


static func gaussian_2D(r1: float = randf(), r2: float = randf()) -> Vector2:
    """
    ported from the caltech lua one (i think, the link is dead!)
    http://www.design.caltech.edu/erik/Misc/Gaussian.html
    r1 and r2 are floats from 0 to 1
    ran_gaussian_2D(randf(),randf())
    """
    var al1 = sqrt(-2 * log(r1)) # part one
    var al2 = 2 * PI * r2 # part two
    var x = al1 * cos(al2)
    var y = al1 * sin(al2)
    return Vector2(x,y)
    

static func gaussian_3D(r1: float = randf(), r2: float = randf(),r3: float = randf(), r4: float = randf()) -> Vector3:
    """
    hacky guassian 3D from the 2D
    """
    var gauss1 = gaussian_2D(r1,r2)
    var gauss2 = gaussian_2D(r3,r4)
    return Vector3(gauss1.x,gauss1.y,gauss2.x)
    
    
