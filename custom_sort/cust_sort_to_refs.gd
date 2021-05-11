"""

obtuse custom sorter built because unable to access the lower levels of the String.sort() function

i needed to get the references back


example:

var test_sort = ["orange","tom","beetroot","apple"]
print(sort_to_refs(test_sort))


should return: [3,2,0,1]



"""


func sort_to_refs(sort_me):
    var sorter2 = []

    for i in sort_me.size(): # build a sort structure (looks like   [[0,"Ted"],[1,"Rob"],[2,"Sam"]]   )
        sorter2.append([i,sort_me[i]])

    sorter2.sort_custom(self, "_sort_to_refs_predicate") # custom sort it

    var ret = [] # get just the references
    for val in sorter2:
        ret.append(val[0])

    return ret


func _sort_to_refs_predicate(a, b):
    """
    alphabetical order sort
    """

    if a is Array: # the input should be arrays with the ref in 0, the value in 1
        a = a[1]
    if b is Array:
        b = b[1]

    if a is String:
        pass
    else:
        a = str(a) # ensure all inputs are strings

    if b is String:
        pass
    else:
        b = str(b) # ensure all inputs are strings

    var ret = b.casecmp_to(a) # case sensitive sort

    if ret == 1: ret = true
    else: ret = false

    return ret


