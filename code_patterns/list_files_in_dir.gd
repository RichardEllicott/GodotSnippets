"""

listing files in a directory

"""


export(String, DIR) var folder_path = "" # export hint for choosing a folder


func list_files_in_directory(path):
    var files = []
    var dir = Directory.new()
    dir.open(path)
    dir.list_dir_begin()

    while true:
        var file = dir.get_next()
        if file == "":
            break
        files.append(file)

    dir.list_dir_end()

    return files



        """
        matching start and fin of filenames with regex (saved for refactor)

        can't seem to get match groups working (if they exist in godot)

        var re = "TROO"
        var regex = RegEx.new()
        # ^ assert starts
        # .* is wildchar
        # \\. escape char to match .
        # $ assert start
        regex.compile("^" + re + ".*" + "\\.png$")
        var result = regex.search(file)
        if result:
#            print("match: ", file)
            print(result.get_strings())
        """