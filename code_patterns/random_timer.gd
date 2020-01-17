"""

quick paste random timer

"""


export var delay = 1.0
export var random_delay  = 1.0
var timer = 0.0
var current_delay = 0.0

func _process(delta):
    timer += delta
    if timer > current_delay:
        timer -= current_delay
        current_delay = delay + randf() * random_delay
        # run code here!
