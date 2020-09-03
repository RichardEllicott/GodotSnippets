"""

builds a nested array of nulls (backwards like python array)

to access the array use:

array[y][x]
array[row][col]


the snippet builds the array by using resize for speed


"""



func build_2D_array(x,y):
    var ret = []
    ret.resize(y) # resize should be faster than appending several times
    for i in y:
        var row = []
        row.resize(x)
        ret[i] = row
    return ret