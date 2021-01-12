extends Label

func _process(delta):
    text = str(    "fps: %s" % [Engine.get_frames_per_second()]       )
