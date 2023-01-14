"""

macro template

"""
tool
extends Node

enum Macro {
    macro01,
    macro02,
   }

export(Macro) var macro = 0

export var trigger_macro = false setget set_trigger_macro
func set_trigger_macro(input):
    if input:
        trigger_macro = false
        _ready() # ensure vars are available
        run_macro(macro)

func run_macro(macro):
    var function_name = Macro.keys()[macro]
    print("print call function: %s" % function_name)
    call(function_name)

func _ready():
    pass

func _process(delta):
    pass
    
func macro01():
    print("macro01...")
    
func macro02():
    print("macro02...")
    
    # EXAMPLES:
    for child in get_children(): # WARNING delete all children example!
        remove_child(child)
    var node = Polygon2D.new() # create a new node in tool mode
    add_child(node)
    node.set_owner(get_tree().edited_scene_root)
    
