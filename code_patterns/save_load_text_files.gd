"""
save load text files


https://godotengine.org/qa/52307/can-you-read-a-textfile-resource-with-gdscript


"""


func load_text_file(path):
    var f = File.new()
    var err = f.open(path, File.READ)
    if err != OK:
        printerr("Could not open file, error code ", err)
        return ""
    var text = f.get_as_text()
    f.close()
    return text


func save_text_file(text, path):
    var f = File.new()
    var err = f.open(path, File.WRITE)
    if err != OK:
        printerr("Could not write file, error code ", err)
        return
    f.store_string(text)
    f.close()



export(String, FILE, "*.txt,*.csv") var system_names_file = "" # create an export link to a txt or csv file in ide