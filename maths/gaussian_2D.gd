"""

useful for randomly distributing things naturally in 2D, can be used for a shotgun blast for example
(a shotgun blast would fall as a 2D normal distribution on a surface)

* note that it is not valid to simply take one dimension and assume this is a 1D Gaussian
* this is because the 2D Gaussian is circular

TODO: Add 1D and 3D functions

some lead to a 1D gaussian:
https://github.com/pgoral/Godot-Gaussian-Random/blob/master/GaussianRandom.gd


NEW NOTES 2021... i ran a test of this algo vs this:
https://github.com/p10tr3k/Godot-Gaussian-Random/blob/master/GaussianRandom.gd
which uses "The Marsaglia polar method"
which is interesting but essentially rerolls randoms rather than using the sin and cos

This orginal 2D method i have been using is faster, even despite generating 2 output values!
i think it is the:
Box-Muller transform

test showed

testing 1'000'000 calculations

time taken: 2146 # this method
time taken: 3534 # "The Marsaglia polar method"


note the RandomNumberGenerator has a guassian, randfn 



"""

func gaussian_2D(r1 = randf(), r2 = randf()):
    """
    ported from the caltech lua one (i think, the link is dead!)
    http://www.design.caltech.edu/erik/Misc/Gaussian.html
    
    https://www.taygeta.com/random/gaussian.html # new link
    
    https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform

    r1 and r2 are floats from 0 to 1

    ran_gaussian_2D(randf(),randf())
    """
    var al1 = sqrt(-2 * log(r1)) # part one
    var al2 = 2 * PI * r2 # part two
    var x = al1 * cos(al2)
    var y = al1 * sin(al2)
    return Vector2(x,y)
