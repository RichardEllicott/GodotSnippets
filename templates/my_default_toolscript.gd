"""
"""
tool
extends %BASE%

export var tool_update = false setget set_tool_update
func set_tool_update(input):
    if input:
        tool_update()
        tool_update = false

func tool_update():
	_ready() # ensure vars are available
    print(self, "run tool_update functions here...")

    # EXAMPLES:
    for child in get_children(): # WARNING delete all children example!
        child.queue_free()

    var node = Polygon2D.new() # create a new node in tool mode
    add_child(node)
    node.set_owner(get_tree().edited_scene_root)


# Declare member variables here. Examples:
# var a%INT_TYPE% = 2
# var b%STRING_TYPE% = "text"


# Called when the node enters the scene tree for the first time.
func _ready()%VOID_RETURN%:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta%FLOAT_TYPE%)%VOID_RETURN%:
#   pass








