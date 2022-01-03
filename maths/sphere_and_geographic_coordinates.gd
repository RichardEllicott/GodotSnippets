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


# WORKING new set from here:
   #http://www.movable-type.co.uk/scripts/latlong.html
   
   
   

func haversine(lat1, lon1, lat2, lon2):
    
    # ported from python 3 version:
    # https://www.geeksforgeeks.org/haversine-formula-to-find-distance-between-two-points-on-a-sphere/
    
    # distance between latitudes
    # and longitudes
    var dLat = (lat2 - lat1) * PI / 180.0
    var dLon = (lon2 - lon1) * PI / 180.0
 
    # convert to radians
    lat1 = (lat1) * PI / 180.0
    lat2 = (lat2) * PI / 180.0
 
    # apply formulae
    var a = (pow(sin(dLat / 2.0), 2.0) +
         pow(sin(dLon / 2.0), 2) *
             cos(lat1) * cos(lat2));
    var rad = 6371.0
    var c = 2.0 * asin(sqrt(a))
    return rad * c
   
   
   
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
