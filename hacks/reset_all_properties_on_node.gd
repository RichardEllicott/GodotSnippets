"""


reset all property values to the default values


this is a hack (imo, an anti-pattern)

it's not recommended, instead reset the properties you want to manually

may crash etc, who knows



"""



func reset_all_properties():

    var inst = get_script().new() # creates new instance of the same script
    var properties = inst.get_property_list() # creates a dictionary of all properties
    for i in properties.size():
        var default_val = inst.get(properties[i].name) # gets the default value from this instance
        set(properties[i].name, default_val) # sets the corrsponding property on this node to the orginal value


