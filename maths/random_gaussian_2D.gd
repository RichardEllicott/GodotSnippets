
func ran_gaussian_2D():
    """
    ported from the caltech lua one (i think, the link is dead!)
    http://www.design.caltech.edu/erik/Misc/Gaussian.html

    """
    var r1 = randf()
    var r2 = randf()

    var al1 = sqrt(-2 * log(r1)) # part one
    var al2 = 2 * PI * r2 # part two

    var x = al1 * cos(al2)
    var y = al1 * sin(al2)

    return Vector2(x,y)