"""
save load text files


https://godotengine.org/qa/52307/can-you-read-a-textfile-resource-with-gdscript


"""


func load_text_file(path):
    """
    load text file return string
    """
    var f = File.new()
    var err = f.open(path, File.READ)
    if err != OK:
        printerr("Could not open file, error code ", err)
        return ""
    var text = f.get_as_text()
    f.close()
    return text


func save_text_file(text, path):
    """
    save string as text file
    """
    var f = File.new()
    var err = f.open(path, File.WRITE)
    if err != OK:
        printerr("Could not write file, error code ", err)
        return
    f.store_string(text)
    f.close()



export(String, FILE, "*.txt,*.csv") var system_names_file = "" # create an export link to a txt or csv file for use in the ide



func load_csv_file(path):
    """
    load a csv file to nested lists like [["Bob", 21], ["Greg", 35]] using built in csv reader
    """
    var ret = []
    var f = File.new()
    var err = f.open(path, File.READ)
    if err != OK:
        printerr("Could not open file, error code ", err)
        return ret
    while !f.eof_reached():
        var csv = f.get_csv_line ()
        ret.append(csv)
    return ret


