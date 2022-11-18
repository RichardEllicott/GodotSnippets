# https://godotengine.org/qa/17524/how-to-find-an-instanced-scene-by-its-name
func _find_node_by_name(root, name):
    """
    finds a node by name in all childs of root
    intended to be used for global find function:
        mylib.find(name)
    """
    if(root.get_name() == name):
        return root
    for child in root.get_children():
        if(child.get_name() == name):
            return child
        var found = _find_node_by_name(child, name)
        if(found):
            return found
    return null

func find(name):
    """
    global find by name (searches whole scene)
    """
    var node = _find_node_by_name(get_tree().get_root(), name)
    if not node:
        print('WARNING: no object found named ""%s"' % name)
    return node



## added depth limit:

# https://godotengine.org/qa/17524/how-to-find-an-instanced-scene-by-its-name
func find_node_by_name(root, name, max_depth = 10, depth = 0):
    """
    SearchTools.find_node_by_name( get_tree().get_root() , "name1")
    
    finds a node by name in all childs of root


    find_node_by_name( get_tree().get_root() , "name1") ## would search whole scene
    """
    if(root.get_name() == name):
        return root
    for child in root.get_children():
        if(child.get_name() == name):
            return child
        var found = find_node_by_name(child, name, max_depth, depth + 1)
        if(found):
            return found
    return null
