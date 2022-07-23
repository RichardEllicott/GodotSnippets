"""

no apologies for my style, i find myself constantly copying patterns over and over

these functions are like copy and paste boilerplate i seem to end up always typing

"""


## my normal pattern for setting node paths, allow us to point to a node from this node in the editor
export (NodePath) var _target_node : NodePath
onready var target_node : Node = get_node(_target_node)

# export to the local path of a scene file
export(String, FILE, "*.tscn,*.scn") var scene_file = ""

# export to choose a local folder
export(String, DIR) var folder_path = ""

export(PackedScene) var packed_scene # normal way of loading packed scene

# export an array of enumerators
enum MyEnum  {
    none,
    apple,
    orange,
    pear,
    carrot,
   }

export(Array, MyEnum) var array = [MyEnum.apple]


## trigger stuff from tool mode in the editor by setting a fake boolean
export var tool_update = false setget set_tool_update
func set_tool_update(input):
    if input:
        tool_update()
        tool_update = false


func tool_update():
    _ready() # ensure vars are available
    print(self, "run tool_update functions here...")
    
    ## OPTIONAL:
    ## for example use the tool script to create child nodes automaticly:
    for child in get_children(): # WARNING delete all children example!
        remove_child(child)

    var node = Spatial.new() # create a new node in tool mode
    add_child(node)
    
    if Engine.editor_hint: # if in tool mode
        node.set_owner(get_tree().edited_scene_root) # ensure we see the change in tool mode





## Creates in the editor a mode menu, that triggers updates on setting the mode

enum Mode {
    demo,
    mode2,
    mode3,
   }

export(Mode) var mode = 0 setget set_mode
func set_mode(input):
    mode = input
    print("Mode set to \"%s\", trigger update!" % [mode])
    match mode:
        Mode.demo:
            pass
        Mode.mode2:
            pass
        Mode.mode3:
            pass
            
            
            
## call a function by the enumerator name
enum Preset {
    none,
    preset_01,
    preset_02,
   }

func preset_01():
    pass

func preset_02():
    pass

export(Preset) var preset = 0 setget set_preset
func set_preset(input):
    preset = input    
    if preset != 0:
        call(Preset.keys()[preset])






## this trick allows quick autosetup of node trees
## example:
## get_or_create_child(self,"Label",Label)
##

func get_or_create_child(parent: Node,node_name: String, node_type = Node) -> Node:
        
    var node = parent.get_node_or_null(node_name) # get the node if present
    if not is_instance_valid(node): # if no node found make one
        node = node_type.new()
        node.name = node_name
        parent.add_child(node)
        node.set_owner(get_tree().edited_scene_root) # show in tool mode
        
    assert(node is node_type) # best to check the type matches
    
    return node




