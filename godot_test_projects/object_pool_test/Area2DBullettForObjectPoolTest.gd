extends Area2D




export var velocity = Vector2()


var lifetime = 2.0

var bullet_pool


var timer = 0.0


func destroy_bullet():
    if not bullet_pool:
        queue_free()

    else:
        get_parent().remove_child(self)
        bullet_pool.bullet_pool.push_back(self)
        timer = 0.0



func _physics_process(delta):

    timer += delta

    global_position += velocity

    if timer > lifetime:
        destroy_bullet()
        timer = 0.0




func _on_Area2D_body_entered(body):
    destroy_bullet()
