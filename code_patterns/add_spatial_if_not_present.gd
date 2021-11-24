"""

add a child spatial node if not already present


not a great pattern yet, only works on direct children


"""



func add_spatial(spatial_name = "NewSpatial"):
    
    var existing_node = get_node(spatial_name)
    
    if not is_instance_valid(existing_node):
        var new_node = Spatial.new()
        new_node.name = spatial_name
        add_child(new_node)
        
        if Engine.editor_hint: # if in editor make visible
            new_node.set_owner(get_tree().get_edited_scene_root())
