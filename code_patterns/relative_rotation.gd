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
