"""

simple hitscan type gun where we make a straight and instant ray

(UNDEVELOPED)

"""
extends Spatial

export var active = false

var fire_timer = 0.0
export var fire_delay = 1.0/4.0

export(PackedScene) var bullet_puff_scene

func fire_bullet():

    print("fire_bullet raycast...")

    var ray_length = 1000.0



    var pos1 = global_transform.origin
    var pos2 = global_transform.origin - global_transform.basis.z * ray_length

    var ray = get_world().get_direct_space_state().intersect_ray(pos1, pos2,[self])

    print(ray)

    var marker = $Marker
    if ray and marker:

        marker.global_transform.origin = ray['position']
        marker.set_as_toplevel(true)
        pass

    pass


func _ready():
#    fire_bullet()
    pass



func _process(delta):

    fire_timer += delta

    if active:
        if Input.is_action_pressed("ui_fire"):

            if fire_timer > fire_delay:
                fire_timer = 0.0
                fire_bullet()
