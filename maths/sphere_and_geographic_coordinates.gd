"""

everything to do with getting the coordinates of spheres, in order to make a spherical world like the earth


"""


## translate rotations on a globe to the actual 3D position
## this is a code version of using the rotation of nodes instead of position

func geographic_coordinate_to_transform(longitude, latitude, _rotation = 0.0, radius = -2.0):
    
    var _transform = Transform()
    _transform = _transform.rotated (Vector3.RIGHT, deg2rad(longitude))
    _transform = _transform.rotated (Vector3.UP, deg2rad(latitude))
    
    _transform = _transform.rotated (Vector3.BACK, deg2rad(latitude))
    
    _transform.origin = _transform.basis.z * radius
    
    return _transform
