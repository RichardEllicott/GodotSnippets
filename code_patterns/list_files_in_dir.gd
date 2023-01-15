"""

listing files in a directory, load all images in directory as dict

"""


static func list_files_in_directory(path : String) -> Array:
    var files = []
    var dir = Directory.new()
    dir.open(path)
    dir.list_dir_begin(true)
    var file = dir.get_next()
    while file != '':
        files += [file]
        file = dir.get_next()
    return files


static func load_all_resources_in_directory(path : String, types : Array = ['.png', '.jpg', '.webp']) -> Dictionary:
    var ret = {}
    for _filename in list_files_in_directory(path):
        for type in types:
            if _filename.ends_with(type): ## filename of valid type
                var key = _filename.split('.')[0]
                var file_path = "%s/%s" % [path,_filename]
                ret[key] = load(file_path)
    return ret
