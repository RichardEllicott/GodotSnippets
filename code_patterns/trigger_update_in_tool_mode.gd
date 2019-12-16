"""

Godot lacks a way for the designer to click a simple button in a tool node, to trigger an update

clicking on the boolean "trigger_update" with this pattern, will cause the node to update.


get/set properties do work with tool mode, but sometimes you may need to reload the scene to trigger the tool


NOTE, we only use a "set" as there is no point to get this variable


"""

tool
extends Node

export var tool_update = false setget set_tool_update
func set_tool_update(new_value):
    tool_update = new_value
    if tool_update:
        tool_update()
        tool_update = false


func tool_update():
	_ready() # ensure vars are available
    print(self, "run tool_update functions here...")