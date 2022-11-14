"""
source:
https://godotengine.org/qa/5175/how-to-get-all-the-files-inside-a-folder
"""

## returns all file and folder names in directory
func list_files_in_directory(path):
    var files = []
    var dir = Directory.new()
    dir.open(path)
    dir.list_dir_begin(true)

    var file = dir.get_next()
    while file != '':
        files += [file]
        file = dir.get_next()

    return files
    
    
## load a whole directory of resources into a dictionary
## used to load all the images in a path for example
func load_all_resources_in_directory(path, types = ['.png', '.jpg']):
    
    var ret = {}
    
    for _filename in list_files_in_directory(path):
        for type in types:
            if _filename.ends_with(type): ## filename of valid type
                var key = _filename.split('.')[0]
                var file_path = "%s/%s" % [path,_filename]
                ret[key] = load(file_path)
    
    return ret
