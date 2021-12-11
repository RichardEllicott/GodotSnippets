"""

no longer much use, use:


var joy_input = Input.get_vector("ui_left","ui_right","ui_up","ui_down")



"""




func _physics_process(delta):

    # get the input (analogue)
    var joy_input = Vector2(
        Input.get_action_strength("ui_right")
            - Input.get_action_strength("ui_left"),
        Input.get_action_strength("ui_up")
            - Input.get_action_strength("ui_down")
       )

