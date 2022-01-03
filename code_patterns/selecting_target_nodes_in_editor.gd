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


# ALTERNATIVE FOR TOOl SCRIPTS:

export(NodePath) var _target_node
var target_node setget , get_target_node # only get
func get_target_node():
    if not target_node: # if no ref
        if not _target_node.is_empty(): # check NodePath not empty
            target_node = get_node(_target_node)
    return target_node







# trigger update when setting variable, works in tool mode
export var target_node2 = false setget set_target_node2

func set_target_node2(new_value):
    show_coordinates = new_value
   
	
	





