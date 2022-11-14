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
