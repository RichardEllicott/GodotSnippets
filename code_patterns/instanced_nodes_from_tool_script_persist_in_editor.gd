"""




"""

tool
Node

export(PackedScene) var packed_scene # set the scene in the editor


func _ready():
	var instance = packed_scene.instance() # create an instance of the scene
	add_child(instance) # add child
	instance.set_owner(get_tree().get_edited_scene_root()) # show the instance in the IDE, allowing you to save it