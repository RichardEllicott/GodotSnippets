# Based on code from https://www.alanzucconi.com/2015/09/16/how-to-sample-from-a-gaussian-distribution
# By Alan Zucconi
# Converted to GDScript by Goral

class_name GaussianRandom

static func nextGaussian() -> float:
    var v1:float
    var v2:float
    var s:float
    var firstPass = true

    while firstPass or s >= 1.0 or s == 0:
        v1 = 2.0 * randf() - 1.0
        v2 = 2.0 * randf() - 1.0
        s = v1 * v1 + v2 * v2
        firstPass = false

    s = sqrt((-2.0 * log(s)) / s)

    return v1 * s

static func nextGaussian2(mean:float, standard_deviation:float) -> float:
    return mean + nextGaussian() * standard_deviation

static func nextGaussian3(mean:float, standard_deviation:float, _min:float, _max:float) -> float:
    var x:float
    var firstPass = true

    while firstPass or x < _min or x > _max:
        x = nextGaussian2(mean, standard_deviation)
        firstPass = false
    return x
