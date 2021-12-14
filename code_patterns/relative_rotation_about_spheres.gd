"""

scraps while solving how to make a geoscape like xcom (units flying around on sphere)


"""


rotate_object_local(Vector3(1, 0, 0),  delta * speed * velocity.x)



func rotate_local(rot: Vector3):

    # using the basis vectors
    rotate(transform.basis.x, rot.x) # forwards N
    rotate(transform.basis.y, rot.y) # strafe E
    rotate(transform.basis.z, rot.z) # rotate clockwise direction

    # alternative
    rotate_object_local(Vector3(1, 0, 0),  rot.x)
    rotate_object_local(Vector3(0, 1, 0),  rot.y)
    rotate_object_local(Vector3(0, 0, 1),  rot.z)


# Stereographic_projection formulae:
func sphere_to_plane_pos(input: Vector3) -> Vector2:
    # https://en.wikipedia.org/wiki/Stereographic_projection
    
    var x = input.x / (1 - input.z)
    var y = input.y / (1 - input.z)
    
    return Vector2(x,y)

func plane_to_sphere_pos(input: Vector2) -> Vector3:
    # https://en.wikipedia.org/wiki/Stereographic_projection
    
    var divisor = (1 + pow(input.x,2.0) + pow(input.y,2.0) ) # 1+X^2+Y^2
    
    var x = (2.0 * input.x) / divisor
    var y = (2.0 * input.y) / divisor
    var z = (-1 + pow(input.x,2.0) + pow(input.y,2.0) ) / divisor
    
    return Vector3(x,y,z)
