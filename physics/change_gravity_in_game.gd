"""
"""


# change the gravity vector midgame

# i use this for pinball for example, to simulate a 6.5 degree slope: Vector3(0, -0.994, 0.113)


PhysicsServer.area_set_param(
    get_world().space,
    PhysicsServer.AREA_PARAM_GRAVITY_VECTOR,
    Vector3(0,0,1))
        
        
