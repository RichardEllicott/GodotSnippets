"""
"""


var pos1 = Vector3()
var pos2 = Vector3(16,0,0)
var ray = get_world().get_direct_space_state().intersect_ray(pos1, pos2,[self])