"""

A weapon controller that spawns a special type of child (modular_fps_raycast_bullet.gd)

This bullet simulates real ballistics and will raycast each physics frame to test for collision


This bullet will not overshoot anything and the velocity can be realistic for a real bullet/tank shell

"""
extends Spatial

export var active = false

var fire_timer = 0.0

export var fire_delay = 0.25



# REFERENCE SPEEDS:

# 1670 m/s M829 120mm Depleted Uranium Tank Round
# 930 m/s 5.56x45mm NATO (AR-15)
# 457 m/s 9x19mm Glock
# 90 m/s paintball
# 90 m/s compound bow
# 78 m/s fastest squash serve
# 67 m/s normal bow
# 64 m/s fastest tennis serve
# 23 m/s trebuchet middle ages



export var fire_velocity = 930.0

export(PackedScene) var bullet_scene

func _process(delta):

    fire_timer += delta

    if active:
        if Input.is_action_pressed("ui_fire"):

            if fire_timer > fire_delay:
                fire_timer = 0.0
                fire_bullet()


func fire_bullet():

    var inst = bullet_scene.instance()
    add_child(inst)
    inst.set_as_toplevel(true)

    inst.bullet_velocity = -global_transform.basis.z * fire_velocity


    var gun_sound = $GunSound
    if gun_sound:
        if gun_sound.visible:
            gun_sound.playing = true
    pass
