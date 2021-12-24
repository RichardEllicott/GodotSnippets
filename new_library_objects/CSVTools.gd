## CSVTools contains a CSVTable class that reads csv tables (which are easy to edit with OpenOffice)
##
## EXAMPLES:
##
## var table = CSVTools.CSVTable(filename) # load the object
##
## table.get_array_of_dicts() # get an array of dicts (similar to the the python DictReader)
## table.get_dict_of_dicts() # get a dict of dicts using the first column as the primary key
##
## as per Godot's built in csv reading, this class uses unicode (utf-8)
##
## i created this class as it's neater than using function snippets
##


class_name CSVTools


## CSVTable object for easy loading/saving of CSV table files
class CSVTable:

    var _filename = "" # csv filename

    var header : Array = [] # list of strings from header

    var body : Array = [] # list of list of strings (the main csv data)

    var _key_to_col : Dictionary = {} # convert a column name to a column int reference
    
    
    ## rebuild the _key_to_col dict, the header array must be present
    func _generate_key_to_col():
        _key_to_col = {}
        var i = 0
        for val in header:
            _key_to_col[val] = i
            i += 1
        
    
    ## clear data to load new data
    func _clear():
    
        header = []
        body = []
        _key_to_col = {}
        
        
        pass

    ## loads a filename, called internally, do not use
    ## stores the data of the csv file into this object for further usage
    func _load_filename(_filename, max_rows):
        
        _clear()
        
        var record_ref = 0
        var start_row = 0
        
        var f = File.new()
        var err = f.open(_filename, File.READ)
        if err != OK:
            printerr("Could not open file, error code ", err)
        else:
            
            var i = -1

            while !f.eof_reached():
                i+= 1
                if i > max_rows:
                    break
                
                var row = f.get_csv_line()
                
                if i < start_row: # ignore
                    pass
                elif i == start_row: # header
                    var i2 = 0
                    for val in row:
                        _key_to_col[val] = i2
                        i2 += 1                    
                    header = row

                else: # records
                    body.append(row)               
                    record_ref += 1
                    
                    
    ## get a record row as a dictionary
    func get_row_as_dict(row = 0):
        var record = body[row] # the record as a array
        var ret = {} # return dict
        for i in header.size():
            ret[header[i]] = record[i]
        return ret

    ## record count
    func get_record_count() -> int:
        return body.size()
    
    ## return a list of record rows as dictionaries (similar to python DictReader)
    func get_array_of_dicts() -> Array:
        var list_of_dicts = [] # retiurn values
        
        for i in body.size():
            list_of_dicts.append(get_row_as_dict(i))
        return list_of_dicts
    


    ## return a dict of dicts, such that the first column serves as a key reference
    func get_dict_of_dicts(primary_key : int = 0) -> Dictionary:
        
        var ret = {} # return dict of dicts
        
        for rec_ref in body.size(): # for each record
            
            var record = body[rec_ref] # record data as a list
            
            var dict_ref = null # the primary key will be found and put here (usually column 0)
            
            var record_dict = {} # dict of the record to return
            
            for col_ref in record.size(): # for each column
                var val = record[col_ref] # the cell value
                
                var key = header[col_ref] # the column name
                
                if col_ref == primary_key: # if we are the primary key
                    dict_ref = val # record the primary key val
                    
                record_dict[key] = val
                
            ret[dict_ref] = record_dict # save the record dict using the found key
                    
        return ret

    ## trunctate or stretch a string to size, adding a * if chars are missing
    func string_to_size(input, size = 8):
        
        input = str(input)
        
        if input.length() > size:
            
            input = input.trim_suffix(' ') # UNSURE IF NEEED
            input = input.trim_prefix(' ') # UNSURE IF NEEED
            
            input = input.substr(0,size-2)
            input += ".."
        
        while input.length() < size:
            input += " "

        return input
        
    
    ## return the data as an ASCII style table for debugging
    func get_pretty_string(col_width = 12):

        var ret = ""
        
        var width = 0
        
        for i in header.size(): # DRAW HORIZONTAL LINE
            for i2 in col_width + 3:
                ret += "-"
        ret += "---"
        ret += "\n"
        
        ret += " | " + "filename: %s\n" % [_filename]
        
        for i in header.size(): # DRAW HORIZONTAL LINE
            for i2 in col_width + 3:
                ret += "-"
        ret += "---"
        ret += "\n"
        
        for key in header:
            
            key = string_to_size(key,col_width)
            
            ret += " | %s" % key
            
        ret += " |"
            
        width = ret.length()
        
        ret += "\n"
        
        for i in header.size(): # DRAW HORIZONTAL LINE
            for i2 in col_width + 3:
                ret += "-"
        ret += "---"
        ret += "\n"
    
        for row in body:
            
            for val in row:
                
                val = string_to_size(val,col_width)
                
                ret += " | %s" % val
            
            ret += " |"
            ret += "\n"
            
        for i in header.size(): # DRAW HORIZONTAL LINE
            for i2 in col_width + 3:
                ret += "-"
        ret += "---"
        ret += "\n"
        
        return ret
        
        
        
    func _to_string():
        return get_pretty_string()
        
        
   ## save the data from header and records into a new csv file
    func save_to_file(_filename):

        var file = File.new()
        var error = file.open(_filename, File.WRITE)
        if error != OK:
            printerr("Could not open file, error code ", error)
        else:
            
            file.store_csv_line(header)
            
            for record in body:
                file.store_csv_line(record)
        file.close()
        
    
    ## load this object from an array_of_dicts instead of a file
    ## even if the dicts have different keys, they will be merged into a super-table
    func load_from_array_of_dicts(array_of_dicts):
        
        _clear()
        
        var detected_keys = {} # null ref dict
        
        for row in array_of_dicts: # first we detect all keys
            for key in row:
                detected_keys[key] = null
                
        header = detected_keys.keys()
        
        print("header: ", header)
        
        _generate_key_to_col() # rebuild the references
        
        var table_width = header.size()
        
        for row in array_of_dicts:
            var new_row = []
            new_row.resize(table_width) # resizing should be faster than appending in a loop
            
            body.append(new_row)
            
            
            for i in header.size():
                var header_label = header[i]
                
                if header_label in row: # add value if we have it
                    new_row[i] = row[header_label]
                
                

    
    ## when loading class, we need to specify the csv filename which will trigger loading
    ## we can now also add an array of dicts
    func _init(_filename, max_rows = 1000000):
        
        if _filename is String: # if string, assume it is a filename
            self._filename = _filename
            _load_filename(_filename,max_rows)
            
        elif _filename is Array:
            if _filename.size() > 0:
                if _filename[0] is Dictionary:
                    print("DETECTED ARRAY OF DICTS")
                    
                    load_from_array_of_dicts(_filename)
                    
                elif _filename[0] is Array:
                    
                    print("DETECTED ARRAY OF ARRAYS")
                    
        elif _filename is Dictionary:
            var keys = _filename.keys()
            if keys.size() > 0:
                var key = keys[0]
                
                if key is Dictionary:
                    
                    print("DETECTED DICT OF DICTS")
                
    

    
