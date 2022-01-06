class_name SphereTools

##
## SphereTools part of my Godot Cogs Library
##
## @desc:
##     The description of the script, what it
##     can do, and any further detail.
##
## @tutorial:            https://docs.godotengine.org/en/latest/tutorials/scripting/gdscript/gdscript_documentation_comments.html
## @tutorial(Tutorial2): http://the/tutorial2/url.com
##

"""

functions:

geo_coor_to_transform
great_circle_distance
get_target_bearing
move_by_bearing_and_distance
world_pos_to_geo_coor
wrap_angle



contains functions to translate geographic (sphere) coordinates

all these functions use degrees, they tend to use and return coordinates as Vecto2s

Vector2(longitude,latitude)


follows the "GCS" system:
    https://en.wikipedia.org/wiki/Geographic_coordinate_system
    
longitude (λ)
latitude (φ)


sources:
    https://www.movable-type.co.uk/scripts/latlong.html # many sourced here, modified from javascript
    
    

"""



# geographical coordinates to a transform (with origin on top of the sphere)
#   useful for getting the 3D world position
static func geo_coor_to_transform(
    longitude: float,
    latitude: float,
    _rotation: float = 0.0,
    radius: float = -1.0
    ) -> Transform:
    """
    a quick method for translating longitude/latitude to a 3D position on a sphere
    
    notes the negative radius -1
    this is because i use a convention of offsetting by -z
    the position given now means the euler angles such that
    
    x = longitude
    y = latitude
    z = rotation
    """
    
    var _transform = Transform()
    
    # old method not required?
#    _transform = _transform.rotated (Vector3.RIGHT, deg2rad(longitude))
#    _transform = _transform.rotated (Vector3.UP, deg2rad(latitude))
#    _transform = _transform.rotated (Vector3.BACK, deg2rad(latitude))

    _transform.basis = Basis(Vector3( # using euler angles is much better
        deg2rad(longitude),
        deg2rad(latitude),
        deg2rad(_rotation)))
    
    _transform.origin = _transform.basis.z * radius
    
    return _transform
    
# distance between two geographical coordinates
static func great_circle_distance(from: Vector2, to: Vector2, radius: float = 6371000.0) -> float:
    """
    # using haversine formulae gives the "great circle distance"
    # https://en.wikipedia.org/wiki/Haversine_formula
    
    # ported from python 3 version:
    # https://www.geeksforgeeks.org/haversine-formula-to-find-distance-between-two-points-on-a-sphere/
    
    seems to work but likely distorts as the earth is not a perfect sphere
    
    some checks:
        
    var London = Vector2(51.507222, -0.1275)
    var Paris = Vector2(48.856613, 2.352222 )
    var Tokyo = Vector2(35.683333, 139.766667 )
    
    # london is 342.76 km   this: :343527.749023
    #  Tokyo and London is 5,939.91 mi (9,559.36 km).  this 9562070
    
    """ 
    
    var lat1 = from.x
    var lon1 = from.y
    
    var lat2 = to.x
    var lon2 = to.y
    

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
    
    var c = 2.0 * asin(sqrt(a))
    return radius * c
    
# get the bearing of a target (to) from a position (from)
static func get_target_bearing(from, to) -> float:
    """
    get the bearing from one gcs coordinate to another in degrees
    
    
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
    
# move from a geo coordinate along a bearing by a distance
static func move_by_bearing_and_distance(
        from: Vector2, # start coordinate Vector2(longitude,latitude)
        bearing: float, # compass bearing in degrees
        distance: float, # distance to travel in meters
        radius: float = 6371000.0 # default earth radius in meters
        ) -> Vector2: # returns new position like Vector2(longitude,latitude)
    """
    
    returns Vector2(longitude,latitude)
    
    ported from the javascript
    "Destination point given distance and bearing from start point"
    https://www.movable-type.co.uk/scripts/latlong.html
    
    oddly the results came out reversed, this is corrected to output the same as the website in decimal
    
    
    TESTS:
    44,128,76,1000*1000 => (45.505836, 140.498779)    web: 45° 30′ 21″ N, 140° 29′ 56″ E
    
    -33,173,-44,1000*1000 =>   (-26.336298, 166.040756)   webb: 26° 20′ 11″ S, 166° 02′ 27″ E   
    """
    
    var longitude = from.x 
    var latitude = from.y
    
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
    
# convert a 3D pos (on or above the sphere) to geographical coordinates
static func world_pos_to_geo_coor(position : Vector3) -> Vector2:
    """
    get lat/long coors from vector3
    
    used to convert raycast result to world position
    
    ported from C#:
    https://stackoverflow.com/questions/5674149/3d-coordinates-on-a-sphere-to-latitude-and-longitude
    
    """

    position = position.normalized() # remove sphere radius
    
    var longitude = asin(position.y)
    var latitude = atan(position.x / position.z); #phi
    
    longitude = rad2deg(longitude)
    latitude = rad2deg(latitude)
    
    if position.z > 0: # when z is positive we need to correct result
        # ensure final angle is from -180° to 180°
        latitude = latitude + 360.0
        latitude = fmod(latitude,360.0) # fmods should get positive numbers
        latitude -= 180.0
        
    return Vector2(longitude, latitude)
    
# wraps a euler angle such that is is between -180 and 180
static func wrap_angle(angle) -> float:
    # https://stackoverflow.com/questions/2320986/easy-way-to-keeping-angles-between-179-and-180-degrees
    # celing version returns a positive 180 degrees (floor version does not)
    return angle - (ceil((angle + 180.0)/360.0)-1.0)*360.0 




# WARNING NOT WORKING (or at least half working)
# this is basicly an ecquirectangular projection

# i need it to find the position of a lat/long on the flat map

static func get_plane_coor(longitude: float,latitude: float) -> Vector2:
    """
    
    in the end adapted from this maths:
        https://en.wikipedia.org/wiki/Equirectangular_projection
        
    the key ideas are the lattitude (x) is linear
    the longitude (y) however distorts and involves a cosine
        
    some random corrections applied
    
    
    MAJOR PROBEM NOT WORKING!
    
    the problem is likely to do with the lattitude distortion as we travel up the map
    
    this is why going up to the UK worked (straight)
    also the equator worked
    
    however more than one long or lat causes distortion 

        
    """
    var y = -longitude * cos(deg2rad(latitude))
    var x = latitude
    
    # setting to -1 -> 1
    x /= 180.0
    y /= 90.0

    # correcting from -1 -> 1  to    0.0 -> 1.0   
    x /= 2.0
    y /= 2.0
    x += 0.5
    y += 0.5
    
    return Vector2(x,y)








# THESE TESTS ARE PRETTY SHODDY
# IT'S FAR EASIER TO TEST THESE FUNCTIONS VISUALLY
static func test():
    
    print("test gcs_coor_to_transform...")
    
    
    print("0,0,-2 ", geo_coor_to_transform(10,0,-2).origin)
    
    
    test_great_circle_distance()
    
static func test_great_circle_distance():
    

    print("testing great_circle_distance()...")
    
    var London = Vector2(51.507222, -0.1275)
    var Paris = Vector2(48.856613, 2.352222 )
    var Tokyo = Vector2(35.683333, 139.766667 )
    
    # london is 342.76 km   this: :343527.749023
    #  Tokyo and London is 5,939.91 mi (9,559.36 km).  this 9562070

    # CONFIRMED THE HAVESINE WORKS BUT IS NOT GOOD ENOUGH FOR NAVIGATION
    # LIKELY DUE TO THE SHAPE OF THE EARTH
    # FINE FOR A VIDEO GAME THOUGH

    print("London->Paris:", great_circle_distance(
        London,
        Paris
       ))
    
    print("London->Tokyo:", great_circle_distance(
        London,
        Tokyo
       ))
    
    
    pass



    
