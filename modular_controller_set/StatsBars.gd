"""
"""
tool
extends HBoxContainer


var health_bar

func set_health_bar(var val = 1.0):

    if not health_bar:
        health_bar = $HealthBar

    if health_bar:
        health_bar.max_value = 1024

        health_bar.value = 1024 * val


        var col = Color.red.linear_interpolate(Color.green, val)

        health_bar.modulate = col


var timer = 0.0

func _process(delta):

    timer += delta


#    set_health_bar(sin(timer) / 2.0 + 0.5)


func _ready():

    set_health_bar(0.75)
