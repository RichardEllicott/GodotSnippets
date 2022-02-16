"""

preliminary code for a drag that has a square relationship

this is arguably physicaly accurate, where linear drag is not really:


https://en.wikipedia.org/wiki/Drag_(physics)


this code majorly simplifies it, all the other numbers are assumed part of a dimensionless coeffecient reduced from this equation:


F = 1/2 p v^2 C A

Force = 1/2 * density * velocity^2 * drag_coefficient * crosssection_area


my_coeffecient = 1/2 * density * drag_coefficient * crosssection_area


F = my_coeffecient * velocity^2



to use the resultant foce:

velocity = velocity + (drag_force * delta)

that is because Force can be expressed as Newtons or acceleration (m/s/s) , multiplying by delta results in m/s


cowboy maybe :)

"""






func negative_pow(base, _exp = 2):
    """
    square function that preserves negative
    
    ie:
        2 => 4
        3 => 9
        -2 => -4 # note power preserved
        -3 => -9
    
    """
    var negative = false
    
    if base < 0:
        negative = true
        base = -base # make positive
        
    base = pow(base,_exp)

    if negative:
        base = -base
        
    return base
    
func square_vec3(vec3):
    return Vector3(
        negative_pow(vec3.x),
        negative_pow(vec3.y),
        negative_pow(vec3.z)
        )

    
func get_drag_force(velocity, coeffecient = 1):
    """
    
    major simplified version of drag, used to approximate friction
    
    if we look at standard drag in physics (fluids, which is the same as air)
    
    https://en.wikipedia.org/wiki/Drag_(physics)
    
    
    F = 1/2 p v^2 C A
    
    Force = 1/2 * density * velocity^2 * drag_coefficient * crosssection_area
    
    
    it's approximtaly correct for a spheroid at sub-sonic speeds
    
    
    the only real important thing to note is that the drag is a square of the speed, not linear
    
    
    thusly my drag coeffecient is also a "dimensionless number", it just has to be set to look right
    

    
    """
    
    var drag = square_vec3(velocity)
    
    drag *= -1.0
    drag *= coeffecient
    
    return drag
