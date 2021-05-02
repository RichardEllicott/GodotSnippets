"""

query in 3D space, should return static colliders an areas

note that for tool scripts, the areas seem reliable but the static colliders not


seemed to detect repeated results, need to test this





"""



func _physics_intersect_cube(var pos = Vector3(), extents = Vector3(1.0,1.0,1.0), max_results = 32):

    var _shape = BoxShape.new() # new cube
    #docs for the pars: https://docs.godotengine.org/en/stable/classes/class_physicsshapequeryparameters.html
    var _query = PhysicsShapeQueryParameters.new() # new query
    _query.collide_with_areas = true # if you want to detect areas
    _query.set_shape(_shape)
    _shape.extents = extents
    _query.transform.origin = pos
    var results = get_world().get_direct_space_state().intersect_shape(_query,max_results)
    return results



func _physics_intersect_sphere(var pos = Vector3(), radius = 1.0, max_results = 32):

    var _shape = SphereShape.new() # new sphere
    #docs for the pars: https://docs.godotengine.org/en/stable/classes/class_physicsshapequeryparameters.html
    var _query = PhysicsShapeQueryParameters.new() # new query
    _query.collide_with_areas = true # if you want to detect areas
    _query.set_shape(_shape)
    _shape.radius = radius
    _query.transform.origin = pos
    var results = get_world().get_direct_space_state().intersect_shape(_query,max_results)
    return results

