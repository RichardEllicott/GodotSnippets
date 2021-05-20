"""

move a laser pointer


parent this node to your fps camera so it points the same direction

ensure you have a child called $Marker which just has to be a visible Spatial like a Sprite3D


NOTE: needs tidy, has a mouse ray solution

"""

extends Spatial

export var active = false


func _ready():
    pass


func _physics_process(delta):

    if active:

        var raycast_laser_marker = $Marker

        if is_instance_valid(raycast_laser_marker): # THIS BLOCK CONTAINS RAYCAST
                raycast_laser_marker.set_as_toplevel(true) # ignore parent not strictly rquired as we update position so often
        #        var hit = _intersect_ray(camera.global_transform.origin,
        #            camera.global_transform.origin - direction * 10000.0)
                var ray_length = 1000.0


                # FIRE AT SCREEN POS LIKE MOUSE AIM
        #        var crosshair_pos = Vector2(1024.0,600.0) / 2.0
        #        var from = camera.project_ray_origin(crosshair_pos)
        #        var to = from + camera.project_ray_normal(crosshair_pos) * ray_length

                # NORMAL RAYCAST

                var camera = self

                var from = camera.global_transform.origin
                var to = camera.global_transform.origin - camera.global_transform.basis.z * ray_length
                var hit = get_world().get_direct_space_state().intersect_ray(from,to)

                if hit:
#                    print("HIT:", hit)
#                    print("raycast hit %s" % [hit.collider.name])
                    raycast_laser_marker.global_transform.origin = hit.position
                    raycast_laser_marker.visible = true

                else:
        #            raycast_laser_marker.global_transform.origin = Vector3(0,2,0)
                    raycast_laser_marker.visible = false


