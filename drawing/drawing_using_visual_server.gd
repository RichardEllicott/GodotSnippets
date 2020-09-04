"""

using the visual server to draw using easy functions (simply use draw, DO NOT use in _draw() function)


link to docs on server (adapted from here):
https://docs.godotengine.org/en/stable/classes/class_visualserver.html#class-visualserver


the "layers" property creates independent layers, last created are at top


"""


var vs_ci_rids

func get_vs_ci_rid(layer = 0):
	"""
	returns a layer ci_rid, creates a new layer if non exists
	"""
    if not vs_ci_rids:
        vs_ci_rids = {}
    if not layer in vs_ci_rids:
        vs_ci_rids[layer] = VisualServer.canvas_item_create()
        VisualServer.canvas_item_set_parent(vs_ci_rids[layer], get_canvas_item()) # Make this node the parent.
    return vs_ci_rids[layer]

# clear a canvas layer
func vs_clear_canvas(layer=0):
    VisualServer.canvas_item_clear(get_vs_ci_rid(layer))

# draw a filled rectangle
func vs_draw_rect(rect,color,layer=0):
    VisualServer.canvas_item_add_rect(get_vs_ci_rid(layer),rect,color)

# draw a line
func vs_draw_line(from,to,color,width,layer=0):
    VisualServer.canvas_item_add_line(get_vs_ci_rid(layer),from,to,color,width,true)

func vs_draw_rect_lines(rect,color,width = 1.0,layer=0):
	"""
	draws a rectangle as lines, like the unfilled rectangle
	"""

    if rect is Vector2: # if it is a Vector2 make a Rect2
        rect = Rect2(Vector2(),rect)

    var c1 = rect.position
    var c2 = Vector2(rect.size.x,0.0) + rect.position
    var c3 = Vector2(rect.size.x,rect.size.y) + rect.position
    var c4 = Vector2(0.0,rect.size.y) + rect.position

    vs_draw_line(c1,c2,color,width,layer)
    vs_draw_line(c2,c3,color,width,layer)
    vs_draw_line(c3,c4,color,width,layer)
    vs_draw_line(c4,c1,color,width,layer)






func vs_draw_grid(rect,color,width,div=8,layer=0):
	"""
	draws a grid of lines inside a "rect" with cells determine by "div"
	"""

    if div is int: # div can be a Vector2 or int, a vector allows an x an y div
        div = Vector2(div,div)

    if rect is Vector2: # if it is a Vector2 make a Rect2
        rect = Rect2(Vector2(),rect)

    var cell_size = Vector2(
        rect.size.x / div.x,
        rect.size.y / div.y)

    for x in div.x + 1: # vertical lines
        var xpos = cell_size.x*x
        var line1_start = Vector2(xpos,0.0) + rect.position
        var line1_end = Vector2(xpos,rect.size.y) + rect.position
        vs_draw_line(line1_start,line1_end,color,width)

    for y in div.y + 1: # horizontal lines
        var ypos = cell_size.y*y
        var line1_start = Vector2(0.0,ypos) + rect.position
        var line1_end = Vector2(rect.size.x,ypos) + rect.position
        vs_draw_line(line1_start,line1_end,color,width)



func _ready():
	"""
	usage example
	"""
	vs_draw_rect(Rect2(0,0,16,16),Color.blue)
    vs_draw_rect(Rect2(16,16,16,16),Color.red)

