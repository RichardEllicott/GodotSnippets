"""

A weapon controller that spawns a special type of child (modular_fps_raycast_bullet.gd)

This bullet simulates real ballistics and will raycast each physics frame to test for collision


This bullet will not overshoot anything and the velocity can be realistic for a real bullet/tank shell



Some suggested reference velocities to test:

# 1670 m/s M829 120mm Depleted Uranium Tank Round
# 960 m/s 5.56x45mm NATO (M16 M855A1 round)
# 715 m/s 7.62×39mm AK47
# 457 m/s 9x19mm Glock
# 290 m/s 45 ACP from M1A1 Thompson submachine gun
# 253 m/s 45 ACP from M1911A1 pistol

# 235 m/s .22 UK Air Rifle 9 grains pellet
# 128 m/s  .22 UK Air Rifle 30 grain pellet (very heavy)

# 90 m/s paintball
# 90 m/s compound bow
# 78 m/s fastest squash serve
# 67 m/s normal bow
# 64 m/s fastest tennis serve
# 23 m/s trebuchet middle ages


note that suprisingly, especially pistol velocities do have a fun visible delay at longer ranges

this suggests, that should a 45ACP bullet actually glow, you could likely dodge them!

i feel it suggest that a real 9mm has a slight advantage because the bullet gets there quicker



"""
extends Spatial

export var active = false

var fire_timer = 0.0

export var fire_delay = 0.25



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
