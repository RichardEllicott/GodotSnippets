"""

scraps while solving how to make a geoscape like xcom (units flying around on sphere)


"""


rotate_object_local(Vector3(1, 0, 0),  delta * speed * velocity.x)



func rotate_local():

    rotate(transform.basis.x, delta * speed * velocity.x) # forwards N
    rotate(transform.basis.y, delta * speed * velocity.y) # strafe E
    rotate(transform.basis.z, delta * speed * velocity.z) # rotate clockwise direction
#
    
    rotate_object_local(Vector3(1, 0, 0),  delta * speed * velocity.x)
    rotate_object_local(Vector3(0, 1, 0),  delta * speed * velocity.y)
    rotate_object_local(Vector3(0, 0, 1),  delta * speed * velocity.z)
