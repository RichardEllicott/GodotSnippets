"""

export hint examples


source:
http://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/gdscript_exports.html#doc-gdscript-exports


"""


enum Enumerators = { # example enumerators
	none,
	apple,
	orange
}

export(EnumsA) var enumerator = 0 # displays in editor

var enumerator_string = Enumerators.keys()[enumerator] # returns a string of enumA

