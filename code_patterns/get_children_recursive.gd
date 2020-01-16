"""

build a list of children and sub-children, i find this easy to find all children in a scene (note though groups may be faster)


this pattern works by recursing (passing itself back to itself)


"""

func get_children_recursive(root):
    var array = [] # return array 
    for child in root.get_children():
        array.append(child) # append this child
        array += get_children_recursive(child) # append results of recursing on children of the child
    return array