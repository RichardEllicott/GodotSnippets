"""

an easy to use physics query, creates the circle automatically

returns a list of all the collisions

only use in the _physics_process(delta) function to avoid locks

"""

var scan_pars # cache the query pars
var scan_shape # cache the query shape to change radius
func intersect_circle(_position,_radius):

    # easy function use like:
    #   intersect_circle(global_position, 16.0)

    # creates a circle at position
    # run in physics process

    var physics_state = get_world_2d().get_direct_space_state()

    if not scan_pars: # cache
        scan_shape = CircleShape2D.new()
        scan_pars = Physics2DShapeQueryParameters.new()
        scan_pars.set_shape(scan_shape)

    scan_shape.radius = _radius
    scan_pars.transform.origin = _position

    return physics_state.intersect_shape(scan_pars)


# for debugging, this will draw in the same position as the query
func _draw_circle(_position,_radius):

    # draw a circle in query position for debugging, note resets the drawing transform

    #hack draws in the global transform
    #https://github.com/godotengine/godot/issues/5428
    var inv = get_global_transform().inverse()
    draw_set_transform(inv.get_origin(), inv.get_rotation(), inv.get_scale())
    draw_circle(_position,_radius,Color(1,0,0,0.25))





