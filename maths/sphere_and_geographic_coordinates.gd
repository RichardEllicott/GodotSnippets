"""

everything to do with getting the coordinates of spheres, in order to make a spherical world like the earth


"""


## WARNING BROKEN!! (not relative)
## translate rotations on a globe to the actual 3D position
## this is a code version of using the rotation of nodes instead of position

func geographic_coordinate_to_transform(longitude, latitude, _rotation = 0.0, radius = -2.0):
    
    var _transform = Transform()
    _transform = _transform.rotated (Vector3.RIGHT, deg2rad(longitude))
    _transform = _transform.rotated (Vector3.UP, deg2rad(latitude))
    
    _transform = _transform.rotated (Vector3.BACK, deg2rad(latitude))
    
    _transform.origin = _transform.basis.z * radius
    
    return _transform


# WORKING:
   #http://www.movable-type.co.uk/scripts/latlong.html
   
func coors_to_bearing(from, to):
    """
    gets the bearing between two sets of longitude lattitude coordinates (in degrees)
    excel:
        ATAN2(COS(lat1)*SIN(lat2)-SIN(lat1)*COS(lat2)*COS(lon2-lon1),SIN(lon2-lon1)*COS(lat2))   
        
    found here:
        http://www.movable-type.co.uk/scripts/latlong.html
    """

    var lat1 = deg2rad(from.x)
    var lon1 = deg2rad(from.y)
    var lat2 = deg2rad(to.x)
    var lon2 = deg2rad(to.y)
    
    var a = sin(lon2-lon1)*cos(lat2)
    var b = cos(lat1)*sin(lat2)-sin(lat1)*cos(lat2)*cos(lon2-lon1)
    
    var bearing = atan2(a,b)
    return rad2deg(bearing)
