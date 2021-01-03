"""

boilerplate copy paste code for some of the VisualServer's canvas drawing functions.


the only real advantage of this is you can draw to the screen progressively unlike the normal _draw function.

for example: I wanted to draw a grid for a music sequencer.
Using separate nodes is pleasant but takes too much memory
Using draw functions requires refreshing the entire grid each time i want to update a cell.
With a visual server i can update one cell at a time.



this boilerplate paste code, handles the canvas generation automatically:


vs_draw_rect(Rect2(0,0,16,16),Color.blue) # draws a blue rectangle (but would set up the layer in the background)


link to docs on the visual server (adapted from here):
https://docs.godotengine.org/en/stable/tutorials/optimization/using_servers.html # snippets
https://docs.godotengine.org/en/stable/classes/class_visualserver.html # reference


the "layers" property creates independent layers, last created are at top

to ensure layers are created in order, initialize them before usage:
    get_vs_ci_rid(0) # this layer created first so on bottom
    get_vs_ci_rid(2)
    get_vs_ci_rid(3)
    get_vs_ci_rid(4) # this layer will be on top

NOTE: it is important to also paste the _notification function, it will unload the canvases when the node is destroyed


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

func _notification(what):
    """
    gets called when this node is freed from memory

    very important if you paste these functions in
    """
    if what == NOTIFICATION_PREDELETE:
        # called when the node is destroyed
        vs_clear_resources() # clear the VisualServer canvases


# clear a canvas layer
func vs_clear_canvas(layer=0):
    VisualServer.canvas_item_clear(get_vs_ci_rid(layer))

# draw a filled rectangle
func vs_draw_rect(rect,color=Color.red,layer=0):
    VisualServer.canvas_item_add_rect(get_vs_ci_rid(layer),rect,color)

# draw a line
func vs_draw_line(from,to,color=Color.red,width=1.0,layer=0,antialiased=true):
    VisualServer.canvas_item_add_line(get_vs_ci_rid(layer),from,to,color,width,antialiased)

# draw a grid using lines like graph paper
func vs_draw_grid(rect,color=Color.red,width=1.0,div=8,layer=0,draw_horizontal=true,draw_vertical=true):
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


# draw a texture, like a sprite
# export(Texture) var texture # use this export to allow setting a texture
func vs_draw_texture_rect(texture,rect,modulate=Color.white,layer=0):
    VisualServer.canvas_item_add_texture_rect(get_vs_ci_rid(layer), rect, texture,false,modulate)

func vs_usage_example():
    vs_draw_rect(Rect2(0,0,16,16),Color.blue)
    vs_draw_rect(Rect2(16,16,16,16),Color.red)


    # PREFFERED NEW STYLE, too annoying copying the functions through:
    VisualServer.canvas_item_add_rect(get_vs_ci_rid(0),Rect2(0,0,16,16),Color.blue)

    VisualServer.canvas_item_add_line(
        get_vs_ci_rid(0),
        from,
        to,
        color_linedef,
        4.0,
        false)





# UNTESTED EXTRAS
func canvas_item_add_circle (pos, radius, color, layer=0):
    VisualServer.canvas_item_add_circle (get_vs_ci_rid(layer), pos, radius, color)




# canvas_item_add_polyline ( RID item, PoolVector2Array points, PoolColorArray colors, float width=1.0, bool antialiased=false )
# 


