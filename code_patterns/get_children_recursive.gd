"""

build a list of children and sub-children, i find this easy to find all children in a scene (though groups may be faster)

"""


func get_children_recursive(root, _depth = 0, _node_list = null):
    """
    recursively find all children of node "root" and return them as a list
    do not use the variables _depth and _node_list which are for passing back data in recursion
    usage examples:
        get_children_recursive(self) # get all children of this node
        get_children_recursive(get_tree().get_root()) # get all children of top node
    """
    if not _node_list:
        _node_list = []
    for child in root.get_children():
        _node_list.append(child)
        get_children_recursive(child, _depth + 1, _node_list)
    return _node_list
