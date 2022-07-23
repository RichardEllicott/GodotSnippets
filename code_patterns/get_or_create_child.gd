"""

quickly create a child node of type if missing (works in tool mode)


"""



## get a child, or create if not available (cannot be static)
## example:
##     var node = get_or_create_child(self,"CITIES",Spatial)
##     
##     var node1 = get_or_create_child(self,"child")
##     var node2 = get_or_create_child(node1,"sub_child") # create child of child like making directories
##



## best version so far
## i would like to just type in a nodepath but you need to feed the parents in here
func get_or_create_child(parent: Node,node_name: String, node_type = Node) -> Node:
        
    var node = parent.get_node_or_null(node_name) # get the node if present
    if not is_instance_valid(node): # if no node found make one
        node = node_type.new()
        node.name = node_name
        parent.add_child(node)
        node.set_owner(get_tree().edited_scene_root) # show in tool mode
        
    assert(node is node_type) # best to check the type matches
    
    return node
        


## example usage of get_or_create_child: 
var _control_nodes
func get_control_nodes():
    if not is_instance_valid(_control_nodes):
      _control_nodes = get_or_create_child(self,"CONTROL",Node)
    return _control_nodes
