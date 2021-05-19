"""
"""
extends Spatial

export var active  = false


export(PackedScene) var bullet_scene

export var fire_velocity = 16.0

func fire_bullet():
    var inst = bullet_scene.instance()
    get_tree().get_root().add_child(inst)


    inst.global_transform = global_transform

    var dir = -inst.global_transform.basis.z

    inst.apply_central_impulse(dir * fire_velocity)

#    print("fire_bullet ", inst)


    if shoot_sound:
        shoot_sound.playing = true

var fire_timer = 0.0
export var fire_delay = 1.0/4.0


onready var shoot_sound = $SoundShoot


func _ready():
    fire_bullet()



func _process(delta):

    fire_timer += delta

    if active:
        if Input.is_action_pressed("ui_fire"):

            if fire_timer > fire_delay:
                fire_timer = 0.0
                fire_bullet()

