"""

not really a physics function but gets the plane position of the mouse in a 3D world not using raycast

"""


func get_mouse_plane_pos() -> Vector3:
    """
    get the mouse position on a plane
    
    this plane faces upwards (0,1,0) and has an origin at (0,0,0)
    
    useful for finding where on a flat floor the mouse is pointing with no raycast
    """
    
    var ray_length = 1000.0
    var camera = get_viewport().get_camera()
    var mouse_pos = get_viewport().get_mouse_position()
    var from = camera.project_ray_origin(mouse_pos)
    var to = from + camera.project_ray_normal(mouse_pos) * ray_length
    
    var plane = Plane(Vector3.UP,0)
    var result = plane.intersects_ray(from,to)
    
    return result
