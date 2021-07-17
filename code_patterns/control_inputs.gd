"""
"""




func _physics_process(delta):

    # get the input (analogue)
    var joy_input = Vector2(
        Input.get_action_strength("ui_right")
            - Input.get_action_strength("ui_left"),
        Input.get_action_strength("ui_up")
            - Input.get_action_strength("ui_down")
       )

