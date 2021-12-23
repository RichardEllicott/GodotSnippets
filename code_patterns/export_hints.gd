"""

export hint examples


source:
http://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/gdscript_exports.html#doc-gdscript-exports


"""

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
