"""

should be added as a singleton to autoloads as "ee5_lib"




"""
extends Node


func _ready():
    print("loading ee5_lib...")


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





var node_list_cache = []

func recursive_node_scan(root, depth = 0):

    if depth == 0:
        node_list_cache = []

    for child in root.get_children():

#        var msg = ""
#        for n in range(depth):
#            msg+= "    "
#        print("rnc: ",msg, child)

        node_list_cache.append(child)


        recursive_node_scan(child, depth+1)

func get_all_nodes():
    recursive_node_scan(get_tree().get_root())
    return node_list_cache



func get_label_font(label):
    """
    kept for notes

    how to get the font property
    """
    return label.get("custom_fonts/font")
