"""

using the visual server to draw using easy functions (simply use draw, DO NOT use in _draw() function)


"""



var vs_ci_rid

func get_vs_ci_rid():
	"""
	this utility function will set up the visual server and a canvas
	"""
    if not vs_ci_rid:
        vs_ci_rid = VisualServer.canvas_item_create()
        VisualServer.canvas_item_set_parent(vs_ci_rid, get_canvas_item()) # Make this node the parent.
    return vs_ci_rid


func vs_draw_rect(rect,color):
	"""
	easy function simply draw, note VS overdraws
	"""
    VisualServer.canvas_item_add_rect(get_vs_ci_rid(),rect,color)


func _ready():
	"""
	usage example
	"""
	vs_draw_rect(Rect2(0,0,16,16),Color.blue)
    vs_draw_rect(Rect2(16,16,16,16),Color.red)

