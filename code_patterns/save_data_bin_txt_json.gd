"""

quick functions to save data as binary (godot's auto serialisation)

strings and json, pretty json for indents


"""


## save in binary data
static func data_to_bin_file(path : String, thing_to_save) -> void:
    var file = File.new()
    file.open(path, File.WRITE)
    file.store_var(thing_to_save)
    file.close()
    

static func data_from_bin_file(var path : String) -> Dictionary:
    var file = File.new()
    file.open(path, File.READ)
    var theDict = file.get_var()
    file.close()
    return theDict
    
## save in text
static func string_to_file(path : String, content : String):
    var file = File.new()
    var err = file.open(path, File.WRITE)
    if err != OK:
        ## https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#enum-globalscope-error
        push_error("failed to open file at: \"%s\"\nerror code: %s" % [path,err])
    file.store_string(content)
    file.close()

static func file_to_string(path : String) -> String:
    var file = File.new()
    var err = file.open(path, File.READ)
    if err != OK:
        ## https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#enum-globalscope-error
        push_error("failed to open file at: \"%s\"\nerror code: %s" % [path,err])
    var content = file.get_as_text()
    file.close()
    return content

# using the text save for json
static func dict_to_json_file(path : String, stuff : Dictionary) -> void:
    string_to_file(path,to_json(stuff))
    
static func dict_to_pretty_json_file(path : String, stuff : Dictionary) -> void:    
    string_to_file(path,JSON.print(stuff,"    "))
    
static func dict_from_json_file(path : String) -> Dictionary:
    return parse_json(file_to_string(path))

## https://godotengine.org/qa/424/how-do-you-check-if-a-file-resource-exist 
static func file_exists(var path : String) -> bool:
    var file = File.new()
    return file.file_exists(path)
