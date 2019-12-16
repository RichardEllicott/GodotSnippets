"""

Godot lacks a way for the designer to click a simple button in a tool node, to trigger an update

clicking on the boolean "trigger_update" with this pattern, will cause the node to update.


get/set properties do work with tool mode, but sometimes you may need to reload the scene to trigger the tool


NOTE, we only use a "set" as there is no point to get this variable


"""

tool
extends Node

export var trigger_update = false setget set_update #setting this var to true, triggers an update
func set_update(new_value):
    trigger_update = new_value
    if trigger_update:
        trigger_update = false
        update()
        
func update():
    print(self, "run update functions here...")