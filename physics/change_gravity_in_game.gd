"""
"""


# change the gravity vector midgame

PhysicsServer.area_set_param(
    get_world().space,
    PhysicsServer.AREA_PARAM_GRAVITY_VECTOR,
    Vector3(0,0,1))
        
        
