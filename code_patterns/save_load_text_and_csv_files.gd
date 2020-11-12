"""
save load text and csv files easy functions


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



func save_csv_file(path, nested_lists):
    """
    save nested lists to csv

    for example:
        [["Bob", 21], ["Greg", 35]]

    results in file:
        Bob,21
        Greg,53

    """
    var f = File.new()
    var err = f.open(path, File.WRITE)
    if err != OK:
        printerr("Could not write file, error code ", err)
        return
    for row in nested_lists:
        f.store_csv_line(row)
    f.close()





func load_table_file(path):
    """
    a table file is a csv file with headers ie:

        name, age, sex
        Bob, 34, male
        Phil, 45, male
        Janet, 33, female

    it will load as a list of dictionarys

    this is useful for loading a table as pseudo objects

    [{name: Bob, age: 32, sex: male}...
    """

    var ret = []

    var csv = load_csv_file(path)

    var keys = csv[0]

    for i in csv.size():
        var entry = {}
        var row = csv[i]
        if i != 0:
            for i2 in row.size():
                entry[keys[i2]] = row[i2]

        if entry.size() > 0: # only add records with keys
            ret.append(entry)

    return ret





func load_table_file_as_dict(path):
    """
    load a csv table as a database such that the top row is the keys (NEW ADDED 26/11/2020)
    
    subsequent rows are entries
    the first row is the id
    
    e.g INPUT:
    
    name, age, sex
    bob, 23, male
    joe, 32, male
    
    """

    var ret = {} # return a dictionary of the entries

    var data = load_csv_file(path)

    var header_row = []
    if data.size() >= 2: # must be 2 or more rows

        for i in data.size():
            var row = data[i]

            var row_key = row[0]

            if i == 0:
                header_row = row
            else:
                var row_dict = {}
                for i2 in row.size():
                    var val = row[i2]

                    row_dict[header_row[i2]] = val

                ret[row_key] = row_dict

    return ret



