"""

an easy to use physics query, creates the circle automatically

returns a list of all the collisions

only use in the _physics_process(delta) function to avoid locks

"""


func intersect_circle(_position,_radius):

    # easy function use like:
    #   intersect_circle(global_position, 16.0)

    # creates a circle at position
    # run in physics process
    var _shape = CircleShape2D.new() # new circle
    var _query = Physics2DShapeQueryParameters.new() # new query
    _query.set_shape(_shape)
    _shape.radius = _radius
    _query.transform.origin = _position
    return get_world_2d().get_direct_space_state().intersect_shape(_query)




# for debugging, this will draw in the same position as the query
func _draw_circle(_position,_radius):

    # draw a circle in query position for debugging, note resets the drawing transform

    #hack draws in the global transform
    #https://github.com/godotengine/godot/issues/5428
    var inv = get_global_transform().inverse()
    draw_set_transform(inv.get_origin(), inv.get_rotation(), inv.get_scale())
    draw_circle(_position,_radius,Color(1,0,0,0.25))





