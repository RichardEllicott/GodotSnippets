"""

quickly create a child node of type if missing (works in tool mode)


this can make setting up a nodetree with children very easy:

var panel : Panel = get_or_create_node('Panel', Panel)
panel.rect_min_size = Vector2(128,64)
var label : Label = get_or_create_node('Panel/Label', Label)
label.text = "hello godot!"

the other function is requires a parent and does not use a path:
var mylabel = get_or_create_child(self,"MyLabel",Label) ## child of this node
var mylabel = get_or_create_child(mylabel,"ChildLabel",Label) ## sub child

it's like calling "get_node_or_null" where it would never return null as it will create the object if required
this allows a very fast dynamic setup... i find it's better than notes to make a script set itself up to a minimum level adding required child nodes if they don't exist

"""


## create a child of the parent if it doesn't already exist
func get_or_create_child(parent: Node,node_name: String, node_type = Node) -> Node:        
    var node = parent.get_node_or_null(node_name) # get the node if present
    if not is_instance_valid(node): # if no node found make one
        node = node_type.new()
        node.name = node_name
        parent.add_child(node)
        node.set_owner(get_tree().edited_scene_root) # show in tool mode
    assert(node is node_type) # best to check the type matches
    return node
    
## create a node using a nodepath, make sure to create parents before childs
func get_or_create_node(nodepath : String, node_type = Node) -> Node:
    var parent : Node = self # assume self is parent
    var node_name : String = nodepath # assume path is name
    var split : PoolStringArray = nodepath.split('/') # we split to check if we have a path
    if split.size() > 1: # if split larger than 1 must be a path
        node_name = split[-1] # the name is the last entry
        split.resize(split.size()-1) # drop the last entry
        var parent_path = split.join('/') # then combine for parent path   
        parent = get_node_or_null(parent_path) # get the parent 
    return get_or_create_child(parent,node_name,node_type)
