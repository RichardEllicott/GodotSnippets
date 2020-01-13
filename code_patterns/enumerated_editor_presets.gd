"""

This preset pattern allows a editor drop down box, it is designed for less typing


When a preset is selected by the designer, it triggers an update that loads a matching function


for example if the preset name is "preset1" then we will check if a function "preset_preset1" exists, and run it



this is useful when you might have different collections of settings and behaviors to load quick and test


"""


enum Preset{ # use a capital letter for the enumerator list itself
    none,
    preset1,
    preset2,
   }

export(Preset) var preset = Preset.none setget set_preset # use small letters for the var, "preset" is the key

func set_preset(value):
	# if the preset loads instances, you may concider freeing previous ones here
    if value != preset:
        preset = value
        var preset_name = Preset.keys()[value] # gets the string name of the preset
#        print("%s sets preset to: %s (%s)" % [self,preset,preset_name]) # debug
        var method_string = "preset_%s" % preset_name
        if has_method(method_string):
            call(method_string)

func preset_none():
    print(self, "calling preset_none...")

func preset_preset1(): # the key name ("preset"), is prepended before an underscore and the enumerator name
	# run functions that make this preset, ie you could set colours and styles
    print(self, "calling preset_preset1...")


func preset_preset2():
    print(self, "calling preset_preset2...")

