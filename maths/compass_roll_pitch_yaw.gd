"""

functions for showing flight instruments mainly

getting the compass bearing is fairly easy, from the basis.z

the roll and pitch need to first calculate a bearing to find then the correct roll/pitch


"""



func get_compass_bearing(_basis : Basis):
    ## bearing in radians (corrosponding to -180° to 180°)
    ## assuming -z is forwards
    ## -z is north
    ## +x is east
    var basis_z : Vector3 = _basis.z    
    var bearing : float = -atan2(basis_z.x,basis_z.z)
    return bearing
    
    
func get_roll(_basis : Basis):
    ## the roll in clockwise assuming -z is forwards

    var basis_y = _basis.y
    
    ## rotate the basis_y by the bearing to cancel out the bearing
    ## note we add the bearing here, it must be anticlockwise to rotate by Vector3(0,1,0)
    basis_y = basis_y.rotated(Vector3(0,1,0),get_compass_bearing(_basis))

    ## now the roll can be computed from the x and y values
    var roll = atan2(basis_y.x,basis_y.y)
#    print(rad2deg(roll))
    return roll
    

func get_pitch(_basis : Basis):
    
    ## the pitch in radians, positive when pitching up
    ## if converted to degrees, ranges from -90.0 to 90.0

    var basis_y = _basis.y
    
    ## we must rotate the basis.y by the bearing first
    basis_y = basis_y.rotated(Vector3(0,1,0),get_compass_bearing(_basis))

    ## now the pitch can be computed from the z and y values
    var pitch = atan2(basis_y.z,basis_y.y)
    
    if basis_y.y < 0.0: ## when the y is negative, so we are upside-down, need to make corrections
        pitch += deg2rad(180.0) # first out by 180.0
        
        pitch += deg2rad(180.0) # then need to fmod back here to -180.0 to 180.0
        pitch = fmod(pitch,deg2rad(360.0))
        pitch -= deg2rad(180.0)
    
#    print(rad2deg(pitch))
    
    return pitch
