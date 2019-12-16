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