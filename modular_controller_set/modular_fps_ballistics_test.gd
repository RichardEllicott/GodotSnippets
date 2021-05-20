"""

a ballistic test to track bullet arcs, only has one bullet at a time

make as child of camera


"""

extends Spatial

export var active = false


var fire_timer = 0.0
export var fire_delay = 1.0/4.0

export(PackedScene) var marker_scene


func _process(delta):

    fire_timer += delta

    if active:
        if Input.is_action_pressed("ui_fire"):

            if fire_timer > fire_delay:
                fire_timer = 0.0
                fire_bullet()


var bullet_active = false
var bullet_pos
var bullet_velocity




export var bullet_fire_velocity = 960.0 # speed of m16 bullet 5.56x45mm
export var bullet_ttl = 1024
var _bullet_ttl = 0


var bullet_pool = []

export var bullet_drop = Vector3(0.0,-9.8,0.0) * 1.0


func spawn_pos_marker(pos):

    pass

export var debug_draw_whole_arc = true


func pool_child(child):
    remove_child(child)
    if child.name.begins_with("POOLCHILD_"):
        bullet_pool.append(child)

func _physics_process(delta):

    if bullet_active:
#        print("physics_process...")

        if not debug_draw_whole_arc:
            for child in get_children():
                pool_child(child)

        var inst

        if bullet_pool.size() > 0:
            inst = bullet_pool.pop_back()
#            print("RECYCLE!!!")
        else:
            inst = marker_scene.instance()
#            print("NEW NO RECYCLE!!!")

        inst.name = "POOLCHILD_"

        var old_pos  = bullet_pos

        bullet_pos += bullet_velocity * delta

        bullet_velocity += bullet_drop * delta

#        bullet_velocity = bullet_velocity * 0.95

#        var bullet_direction = bullet_velocity.normalized()
#        var air_resistance = pow(bullet_velocity.length(),2.0) / 10.0
#        air_resistance = (-bullet_direction) * air_resistance
#        bullet_velocity += air_resistance

        add_child(inst)
        inst.set_as_toplevel(true)

        inst.global_transform.origin = bullet_pos

        _bullet_ttl -= 1
        if _bullet_ttl < 0:
            bullet_active = false

        inst.modulate = Color.cyan
        inst.modulate[3] = 0.25


        var space_state = get_world().get_direct_space_state()
        var pos1 = old_pos
        var pos2 = bullet_pos
        var ray = space_state.intersect_ray(pos1, pos2,[self])

        if ray.size() > 0:
            print("RAY ", ray)
            bullet_active = false


            var inst2 = marker_scene.instance()
            add_child(inst2)
            inst2.set_as_toplevel(true)
            inst2.modulate = Color.yellow
            inst2.global_transform.origin = ray['position']
#                break

    pass



func fire_bullet():

    print("ballistics test fire_bullet...")

    for child in get_children():
        remove_child(child)

        if child.name.begins_with("POOLCHILD_"):
            bullet_pool.append(child)


#    fire_bullet_sim1()

    fire_bullet_sim2()



func fire_bullet_sim2():

    print("fire_bullet_sim2...")


    bullet_pos = global_transform.origin
    bullet_velocity = -global_transform.basis.z * bullet_fire_velocity
    bullet_active = true
    _bullet_ttl = bullet_ttl




    pass

func fire_bullet_sim1():


    var pos = global_transform.origin

    var direction = -global_transform.basis.z

    var velocity = direction * 2.0



    var has_it_surface = false


    var space_state = get_world().get_direct_space_state()

    for i in 32:
        var inst = marker_scene.instance()
        add_child(inst)
        inst.set_as_toplevel(true)

        var old_pos = pos

        inst.global_transform.origin = pos

        inst.scale = Vector3(1.0,1.0,1.0) / 2.0

        inst.modulate = Color.cyan
#        inst.modulate[3] = 0.5

        pos += velocity

        pos += Vector3(0,-9.8,0) / 100.0

        if not has_it_surface:

            var pos1 = old_pos
            var pos2 = pos
            var ray = space_state.intersect_ray(pos1, pos2,[self])

            if ray.size() > 0:
                print("RAY ", ray)
                has_it_surface = true


                var inst2 = marker_scene.instance()
                add_child(inst2)
                inst2.set_as_toplevel(true)
                inst2.modulate = Color.yellow
                inst2.global_transform.origin = ray['position']
                break

