"""

in this short example is how to create simple string based presets that take advantage of "reflection" possible in a dynamic language


calling set_preset("preset_reference")

will set parameters on the node to preset settings


this is very useful for a component model, rather than create separate objects, create presets
i use it for my gun selection code

"""



var preset_dict = {
    "pistol": {"fire_delay": 1.0},
    "shotgun": {"fire_delay": 1.0},
    "machinegun": {"fire_delay": 0.125},
   }

func set_preset(preset_ref):

    var data = preset_dict[preset_ref]

    for key in data:
        var val = data[key]
#        print("set data %s %s" % [key,val])
        set(key, val)


var preset setget set_preset

