"""

as opposed to targeting nodes manually in code like:

	var target_node = $NodeName
	var target_node = $"../SiblingName"


using this method means you can point them in the editor.
Also the editor will follow them around if you move them (like camera to the PathFollow2D etc)


I use this convention, the underscored variable is NodePath, the actual node has no underscore



"""

extends Node

export(NodePath) var _target_node
onready var target_node = get_node(_target_node)




# trigger update when setting variable, works in tool mode
export var target_node2 = false setget set_target_node2

func set_target_node2(new_value):
    show_coordinates = new_value
   
	
	
	
# get only property that works in tool mode, make sure though to call get_target3() locally
export(NodePath) var _target3
var target3 setget , get_target3

func get_target3():
    if not target3:
        target3 = get_node(_target3)
    return target3
