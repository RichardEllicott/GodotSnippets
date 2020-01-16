"""

build a list of children and sub-children, i find this easy to find all children in a scene (though groups may be faster)

this pattern works by recursion (passing itself back to itself)



"""

func get_children_recursive(root, depth = 0):
    var array = []
    if depth < 8:
        for child in root.get_children():
            array.append(child)
            array += get_children_recursive(child, depth + 1) # append results of recursing on children of the child
    return array
