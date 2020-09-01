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


# Creates in the editor a mode menu, that triggers updates on setting the mode

enum Mode {
    mode1,
    mode2,
    mode3,
   }

export(Mode) var mode = false setget set_mode
func set_mode(input):
    mode = input
    print("Mode set to \"%s\", trigger update!" % [mode])
    match mode:
    	Mode.mode1:
    		pass
    	Mode.mode2:
    		pass
    	Mode.mode3:
    		pass





