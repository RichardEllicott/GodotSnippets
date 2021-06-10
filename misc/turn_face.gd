"""

nice snippet to smoothly turn a camera

https://www.reddit.com/r/godot/comments/8kpxj6/can_anyone_help_me_with_math_3d/



has some issue turning weird directions



"""




func turn_face(target, delta):
    var rotation_speed = 3
    var target_pos = target.global_transform.origin
    var pos = global_transform.origin
    target_pos.y = pos.y  #comment this line if want rotation to rotate only all axis
    var origin_rot = rotation
    look_at(target_pos, Vector3(0,1,0))
    var target_rot = rotation
    var rot_length = target_rot - origin_rot
    var rot_step = rot_length * rotation_speed * delta
    rotation = origin_rot + rot_step
