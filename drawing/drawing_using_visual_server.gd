"""

using the visual server to draw using easy functions (simply use draw, DO NOT use in _draw() function)


link to docs on server (adapted from here):
https://docs.godotengine.org/en/stable/tutorials/optimization/using_servers.html # snippets
https://docs.godotengine.org/en/stable/classes/class_visualserver.html # reference


the "layers" property creates independent layers, last created are at top


"""


var vs_ci_rids # saves a dictionary of canvas layers

func get_vs_ci_rid(layer = 0):
	"""
	returns a layer ci_rid, creates a new layer if non exists
	"""
    if not vs_ci_rids: # if no canvas dict
        vs_ci_rids = {}
    if not layer in vs_ci_rids: # if we need a new layer create one
        vs_ci_rids[layer] = VisualServer.canvas_item_create()
        VisualServer.canvas_item_set_parent(vs_ci_rids[layer], get_canvas_item()) # Make this node the parent.
    return vs_ci_rids[layer]

func vs_clear_resources():
    """
    clears all the canvases cids, freeing memory
    """
    if vs_ci_rids:
        for key in vs_ci_rids:
            var cid = vs_ci_rids[key]
            VisualServer.canvas_item_clear(cid)




# clear a canvas layer
func vs_clear_canvas(layer=0):
    VisualServer.canvas_item_clear(get_vs_ci_rid(layer))

# draw a filled rectangle
func vs_draw_rect(rect,color=Color.red,layer=0):
    VisualServer.canvas_item_add_rect(get_vs_ci_rid(layer),rect,color)

# draw a line
func vs_draw_line(from,to,color=Color.red,width=1.0,layer=0):
    VisualServer.canvas_item_add_line(get_vs_ci_rid(layer),from,to,color,width,true)



func vs_draw_grid(rect,color=Color.red,width=1.0,div=8,layer=0,draw_horizontal=true,draw_vertical=true):
    """
    draws a grid using lines, based on a rect given
    the div determines the amount of cells (there is div+1 lines per a grid)
    """
    if div is int:
        div = Vector2(div,div)

    if rect is Vector2: # if it is a Vector2 make a Rect2
        rect = Rect2(Vector2(),rect)

    var cell_size = Vector2(
        rect.size.x / div.x,
        rect.size.y / div.y)

    if draw_vertical:
        for x in div.x + 1: # draw vertical lines
            var xpos = cell_size.x*x
            var start = Vector2(xpos,0.0) + rect.position
            var end = Vector2(xpos,rect.size.y) + rect.position
            vs_draw_line(start,end,color,width,layer)

    if draw_horizontal:
        for y in div.y + 1: # draw horizontal lines
            var ypos = cell_size.y*y
            var start = Vector2(0.0,ypos) + rect.position
            var end = Vector2(rect.size.x,ypos) + rect.position
            vs_draw_line(start,end,color,width,layer)



func vs_draw_texture_rect(texture,rect,modulate=Color.white,layer=0):
	"""
	put an export in the script:
		export(Texture) var texture
	then load it with this function

	https://docs.godotengine.org/en/stable/classes/class_visualserver.html#class-visualserver-method-canvas-item-add-texture-rect-region
	"""

    VisualServer.canvas_item_add_texture_rect(get_vs_ci_rid(layer), rect, texture,false,modulate)




func _notification(what):
    if what == NOTIFICATION_PREDELETE:
        # called when the node is destroyed
        vs_clear_resources() # clear the VisualServer canvases




func _ready():
	"""
	usage example
	"""
	vs_draw_rect(Rect2(0,0,16,16),Color.blue)
    vs_draw_rect(Rect2(16,16,16,16),Color.red)

