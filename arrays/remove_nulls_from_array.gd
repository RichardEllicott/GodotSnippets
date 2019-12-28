"""

removes the nulls from an array

like:
	[1,2,null,3,null,'foo', null, 'bar'] => [1,2,3,'foo','bar']

the idea of this is the array is only resized a few times after searching and deleting by placing nulls
similar to how lua uses None


"""

func remove_nulls(input_array):

    # returns a new list with all the nulls removed
    # i.e [1,2,null,3,null,4] => [1,2,3,4]
    # for usage of lua nulls style pattern
    # the array is only resized a few times with this method for better performance
    
    var ret = []
    ret.resize(input_array.size()) # allocate maximum possible size in case no nulls
    var n = 0 # current reference
    for i in range(input_array.size()):
        var val = input_array[i]
        if val != null:
            ret[n] = val # set the data by reference
            n += 1
    ret.resize(n) # chop array to final size
    return ret


func remove_match(input_array, _match = -1):

    # example of using remove_nulls pattern
    # i.e removing the -1's results in:
    # [62,-1,33,-1] => [62,33]
    # the array is only resized a few times with this method for better performance

    var ret = input_array.duplicate()
    for i in range(ret.size()):
        if ret[i] == _match:
            ret[i] = null
    ret = remove_nulls(ret)
    return ret


