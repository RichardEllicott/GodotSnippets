"""

hack to draw ignoring the transform, useful for drawing debug lines between things etc

"""


func _draw():
    var inv = get_global_transform().inverse()
    draw_set_transform(inv.get_origin(), inv.get_rotation(), inv.get_scale())

