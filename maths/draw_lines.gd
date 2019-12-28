"""


source:

https://godotengine.org/qa/35276/tile-based-line-drawing-algorithm-efficiency


the first float method seems to work the fastest


"""

#Returns a set of points from p0 to p1 using linear interpolation
#use: interpolated_line([0, 0], [10, 10])
func interpolated_line(p0, p1):
    var points = []
    var dx = p1[0] - p0[0]
    var dy = p1[1] - p0[1]
    var N = max(abs(dx), abs(dy))
    for i in N + 1:
        var t = float(i) / float(N)
        var point = [round(lerp(p0[0], p1[0], t)), round(lerp(p0[1], p1[1], t))]
        points.append(point)
    return points


#Returns a set of points from p0 to p1 using Bresenham's line algorithm
#use: line([0, 0], [10, 10])
func line(p0, p1):
    var points = []
    var dx = abs(p1[0] - p0[0])
    var dy = -abs(p1[1] - p0[1])
    var err = dx + dy
    var e2 = 2 * err
    var sx = 1 if p0[0] < p1[0] else -1
    var sy = 1 if p0[1] < p1[1] else -1
    while true:
        points.append([p0[0], p0[1]])
        if p0[0] == p1[0] and p0[1] == p1[1]:
            break
        e2 = 2 * err
        if e2 >= dy:
            err += dy
            p0[0] += sx
        if e2 <= dx:
            err += dx
            p0[1] += sy
    return points