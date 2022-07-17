"""

no apologies for my style, i find myself constantly copying patterns over and over

these functions are like copy and paste boilerplate i seem to end up always typing

"""


## my normal pattern for setting node paths, allow us to point to a node from this node in the editor
export (NodePath) var _target_node : NodePath
onready var target_node : Node = get_node(_target_node)


## trigger stuff from tool mode in the editor by setting a fake boolean
export var tool_update = false setget set_tool_update
func set_tool_update(input):
    if input:
        tool_update()
        tool_update = false


func tool_update():
    _ready() # ensure vars are available
    print(self, "run tool_update functions here...")



    # for example use the tool script to create child nodes automaticly:
    for child in get_children(): # WARNING delete all children example!
        remove_child(child)

    var node = Spatial.new() # create a new node in tool mode
    add_child(node)
    
    if Engine.editor_hint: # if in tool mode
        node.set_owner(get_tree().edited_scene_root) # ensure we see the change in tool mode

func _ready():
    pass # Replace with function body.






