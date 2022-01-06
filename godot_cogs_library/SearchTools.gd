class_name SearchTools

##
## SearchTools part of my Godot Cogs Library
##
## @desc:
##     The description of the script, what it
##     can do, and any further detail.
##
## @tutorial:            https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript_documentation_comments.html
## @tutorial(Tutorial2): http://the/tutorial2/url.com
##

"""

NEW

not sure what to do yet, this might work better as a search object



"""



# https://godotengine.org/qa/17524/how-to-find-an-instanced-scene-by-its-name
func find_node_by_name(root, name, max_depth = 10, depth = 0):
    """
    SearchTools.find_node_by_name( get_tree().get_root() , "name1")
    
    finds a node by name in all childs of root
    intended to be used for global find function:
        mylib.find(name)
        
        
    call like SearchTools.find_node_by_name( get_tree().get_root() , "name1")
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


    
