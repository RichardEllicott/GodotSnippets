"""
"""
extends Spatial

var active = true


var bullet_velocity: Vector3 = Vector3()





var bullet_ttl = 10.0




var bullet_drop = Vector3(0.0,-9.8,0.0)



func _physics_process(delta):

    if destroy_me:
        destroy_timer -= delta
        if destroy_timer < 0.0:
            queue_free()

    bullet_ttl -= delta
    if bullet_ttl <= 0.0:
        active = false
        destroy()

    if active:


        var old_pos = global_transform.origin

        global_transform.origin += bullet_velocity * delta

        bullet_velocity += bullet_drop * delta

        var space_state = get_world().get_direct_space_state()
        var pos1 = old_pos
        var pos2 = global_transform.origin
        var ray = space_state.intersect_ray(pos1, pos2,[self])

        if ray.size() > 0: # we have hit a target

            active = false

            global_transform.origin = ray['position']

            if $Marker:
                $Marker.modulate = Color.yellow

            destroy()


var destroy_timer = 1.0
var destroy_me = false

func destroy():

#    queue_free()
    destroy_me = true
    destroy_timer = 2.0

#    if $AudioStreamPlayer3D:

    var gun_sound = $HitSound
    if gun_sound:
        if gun_sound.visible:
            gun_sound.playing = true

#    if bullet_active:
##        print("physics_process...")
#
#        if not debug_draw_whole_arc:
#            for child in get_children():
#                pool_child(child)
#
#        var inst
#
#        if bullet_pool.size() > 0:
#            inst = bullet_pool.pop_back()
##            print("RECYCLE!!!")
#        else:
#            inst = marker_scene.instance()
##            print("NEW NO RECYCLE!!!")
#
#        inst.name = "POOLCHILD_"
#
#        var old_pos  = bullet_pos
#
#        bullet_pos += bullet_velocity * delta
#
#        bullet_velocity += bullet_drop * delta
#
##        bullet_velocity = bullet_velocity * 0.95
#
##        var bullet_direction = bullet_velocity.normalized()
##        var air_resistance = pow(bullet_velocity.length(),2.0) / 10.0
##        air_resistance = (-bullet_direction) * air_resistance
##        bullet_velocity += air_resistance
#
#        add_child(inst)
#        inst.set_as_toplevel(true)
#
#        inst.global_transform.origin = bullet_pos
#
#        _bullet_ttl -= 1
#        if _bullet_ttl < 0:
#            bullet_active = false
#
#        inst.modulate = Color.cyan
#        inst.modulate[3] = 0.25
#
#
#        var space_state = get_world().get_direct_space_state()
#        var pos1 = old_pos
#        var pos2 = bullet_pos
#        var ray = space_state.intersect_ray(pos1, pos2,[self])
#
#        if ray.size() > 0:
#            print("RAY ", ray)
#            bullet_active = false
#
#
#            var inst2 = marker_scene.instance()
#            add_child(inst2)
#            inst2.set_as_toplevel(true)
#            inst2.modulate = Color.yellow
#            inst2.global_transform.origin = ray['position']
##                break
#
#    pass
