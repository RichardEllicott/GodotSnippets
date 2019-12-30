"""

an easy to use physics query, that just does a circle


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