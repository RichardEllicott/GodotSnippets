"""

functions for showing flight instruments mainly




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
