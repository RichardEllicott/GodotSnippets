"""

raycasting examples


"""


var pos1 = Vector3()
var pos2 = Vector3(16,0,0)
var ray = get_world().get_direct_space_state().intersect_ray(pos1, pos2,[self])


# raycast from the mouse position into screen, use to select nodes in 3D
func raycast_mouse_target(ray_length = 100.0):
    var camera = get_viewport().get_camera()
    var mouse_pos = get_viewport().get_mouse_position()
    var from = camera.project_ray_origin(mouse_pos)
    var to = from + camera.project_ray_normal(mouse_pos) * ray_length
    var space_state = get_world().direct_space_state
    var result = space_state.intersect_ray(from, to,[self])
    return result


