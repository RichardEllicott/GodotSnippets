"""

useful for randomly distributing things naturally in 2D, can be used for a shotgun blast for example
(a shotgun blast would fall as a 2D normal distribution on a surface)

* note that it is not valid to simply take one dimension and assume this is a 1D Gaussian
* this is because the 2D Gaussian is circular

TODO: Add 1D and 3D functions


"""

func gaussian_2D(r1 = randf(), r2 = randf()):
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