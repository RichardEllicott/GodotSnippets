

## save in binary data
static func save_data(var path : String, var thing_to_save) -> void:
    var file = File.new()
    file.open(path, File.WRITE)
    file.store_var(thing_to_save)
    file.close()
    
static func load_data (var path : String) -> Dictionary:
    var file = File.new()
    file.open(path, File.READ)
    var theDict = file.get_var()
    file.close()
    return theDict
