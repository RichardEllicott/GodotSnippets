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
    
    
    
func travel_along_bearing(longitude=-33,latitude=173, bearing=-44, distance=1000*1000,radius = 6371000.0):
    """
    
    travel from a longitude/latitude earth coordinate using a bearing in degrees for a distance in meters
    
    returns Vector2(longitude,latitude)
    
    ported from the javascript
    "Destination point given distance and bearing from start point"
    https://www.movable-type.co.uk/scripts/latlong.html
    
    oddly the results came out reversed, this is corrected to output the same as the website in decimal
    
    
    TESTS:
    44,128,76,1000*1000 => (45.505836, 140.498779)    web: 45° 30′ 21″ N, 140° 29′ 56″ E
    
    -33,173,-44,1000*1000 =>   (-26.336298, 166.040756)   webb: 26° 20′ 11″ S, 166° 02′ 27″ E   


    """
    
    latitude = deg2rad(latitude) # we must convert our input degrees to radians 
    longitude = deg2rad(longitude)
    
    bearing = deg2rad(bearing) # bearing also converted from degrees to radians
    
    
    var distance_by_radius = distance/radius # we do not convert this to radians
    
    var longitude2 = asin( sin(longitude)*cos(distance_by_radius) +
                      cos(longitude)*sin(distance_by_radius)*cos(bearing) );
                    
    var latitude2 = latitude + atan2(sin(bearing)*sin(distance_by_radius)*cos(longitude),
                           cos(distance_by_radius)-sin(longitude)*sin(longitude2));
                        
                        
    longitude2 = rad2deg(longitude2)
    latitude2 = rad2deg(latitude2)
    

    return Vector2(longitude2,latitude2) # return radians to degrees
