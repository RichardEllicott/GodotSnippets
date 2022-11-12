"""

Godot lacks a way for the designer to click a simple button in a tool node, to trigger an update

clicking on the boolean "trigger_update" with this pattern, will cause the node to update.


get/set properties do work with tool mode, but sometimes you may need to reload the scene to trigger the tool


NOTE, we only use a "set" as there is no point to get this variable


"""


# creates in the ide, a boolean tick box that when you try to set, instead triggers an update but remains false


tool
extends Node

func _ready():
    pass # Replace with function body.

export var tool_update = false setget set_tool_update
func set_tool_update(input):
    if input:
        tool_update()
        tool_update = false


func tool_update():
    _ready() # ensure vars are available
    print(self, "run tool_update functions here...")

#    # EXAMPLES:
#    for child in get_children(): # WARNING delete all children example!
#        remove_child(child)
#
#    var node = Polygon2D.new() # create a new node in tool mode
#    add_child(node)
#    node.set_owner(get_tree().edited_scene_root)


## reflection pattern that would call a function named by an enumerator


enum Macro {
    macro_load_print_cards,
    example_layout,
   }

export(Macro) var macro = 0


call(Mode.keys()[mode]) ## would call the function



## Creates in the editor a mode menu, that triggers updates on setting the mode


enum Mode {
    demo,
    mode2,
    mode3,
   }

export(Mode) var mode = 0 setget set_mode
func set_mode(input):
    mode = input
    print("Mode set to \"%s\", trigger update!" % [mode])
    match mode:
        Mode.demo:
            pass
        Mode.mode2:
            pass
        Mode.mode3:
            pass



