"""

quickly create a child node of type if missing (works in tool mode)


"""



## get a child, or create if not available
func get_or_create_child(parent,node_name, node_type = Spatial):
    
    var node_ref = parent.get_node_or_null(node_name)
    if not is_instance_valid(node_ref): # if no node found make one
        node_ref = node_type.new()
        node_ref.name = node_name
        parent.add_child(node_ref)
        node_ref.set_owner(get_tree().edited_scene_root)
        
    assert(node_ref is node_type) # best to check the type matches
    
    return node_ref
