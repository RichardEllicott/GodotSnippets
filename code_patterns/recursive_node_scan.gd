"""

recursing all nodes

how to get all nodes in a scene or children of a node

"""


func recursive_get_nodes(root, _depth = 0, _node_list = null):
    """
    recursively find all children of node "root" and return them as a list

    do not use the variables _depth and _node_list which are for passing back data in recursion

    usage examples:
        recursive_get_nodes(self) # get all children of this node
        recursive_get_nodes(get_tree().get_root()) # get all children of top node

    """
    if not _node_list:
        _node_list = []
    for child in root.get_children():
        _node_list.append(child)
        recursive_get_nodes(child, _depth + 1, _node_list)
    return _node_list







