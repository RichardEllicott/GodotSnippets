extends Node2D


var fire_direction = 0.0
var fire_angle = 13.637

var fire_speed = 1/2.0


var bullet_lifetime = 4.0

export(PackedScene) var packed_bullet_scene # normal way of loading packed scene



export var enable_pooling = false


var bullet_pool = []



func spawn_bullet():


    var inst

    if bullet_pool.size() > 0:

        inst = bullet_pool.pop_front()
        print("pool return!!")

    else:
        inst = packed_bullet_scene.instance()


        if enable_pooling:
            inst.bullet_pool = self


    inst.lifetime = bullet_lifetime

    inst.timer = 0.0

    inst.velocity = Vector2(
        sin(deg2rad(fire_direction)),
        cos(deg2rad(fire_direction))
       ) * fire_speed

    fire_direction += fire_angle



    add_child(inst)

    inst.position = Vector2()





func _ready():
    pass # Replace with function body.


var timer = 0.0
var delay = 1.0/64.0


func _process(delta):
    timer += delta
    if timer > delay:

        timer -= delay


        spawn_bullet()


    pass
