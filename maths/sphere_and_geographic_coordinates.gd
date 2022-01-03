"""

everything to do with getting the coordinates of spheres, in order to make a spherical world like the earth


i'm working on these at the moment to make a "geoscape" (like xcom)


so far between coors_to_bearing and travel_along_bearing we have a solution for flying to targets

note how the compass bearings change as we fly, this is the main source of misery, it's okay though because like a GPD we can calculate bearing each frame



most of them ported from here:
https://www.movable-type.co.uk/scripts/latlong.html

there's probabally some  innacuracy towards the poles, being on the pole certainly would break.
there are vector alternatives to using angles, these might improve things

https://www.movable-type.co.uk/scripts/latlong-vectors.html#intersection


"""


## WARNING BROKEN!! (not relative)
## translate rotations on a globe to the actual 3D position
## this is a code version of using the rotation of nodes instead of position

func geographic_coordinate_to_transform(longitude, latitude, _rotation = 0.0, radius = -2.0):

    """
    
    i think this one works actually, it converts long/lat to a Vector3 world pos
    
    the problem i have is converting the Vector3 back, i have no working opposite function
    
    """
    
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

    get the bearing from one coordinate to another
    
    ported from "Bearing":
    http://www.movable-type.co.uk/scripts/latlong.html
    
    for some reason i had to reverse the long/lat
    
    
    """

    var longitude = deg2rad(from.x) # x is the longitude
    var latitude = deg2rad(from.y) # y the lattitude (to keep in map convention)
    var longitude2 = deg2rad(to.x)
    var latitude2 = deg2rad(to.y)
    
    var a = sin(latitude2-latitude)*cos(longitude2)
    var b = cos(longitude)*sin(longitude2)-sin(longitude)*cos(longitude2)*cos(latitude2-latitude)
    
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
