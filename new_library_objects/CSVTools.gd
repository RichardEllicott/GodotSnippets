## CSVTools contains a CSVTable class that reads csv tables (which are easy to edit with OpenOffice)
##
## EXAMPLE:
## var csv_table = CSVTools.CSVTable(filename) # load the object
## csv_table.get_list_of_dicts() # get a list of rows as dicts
## csv_table.get_keyed_data() # get a dict of dicts using the first column as the primary key
##
## as per Godot's built in csv reading, this class uses unicode (utf-8)
##
## i created this class as it's neater than using function snippets
##


class_name CSVTools

class CSVTable:
    """
    class to load a csv table file such that the first row is the headers
    """

    var _filename # csv filename

    var header : Array = [] # list of strings from header

    var body : Array = [] # list of list of strings (the main csv data)

    var _key_to_col : Dictionary = {} # convert a column name to a column int reference

    ## loads a filename, called internally, do not use
    ## stores the data of the csv file into this object for further usage
    func _load_filename(_filename, max_rows):
        
        # reset these variables
        _filename = _filename 
        header = []
        body = []
        _key_to_col = {}
        
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
    
    
    ## return a list of record rows as dictionaries (similar to python DictReader)
    func get_list_of_dicts():
        var list_of_dicts = [] # retiurn values
        
        for i in body.size():
            list_of_dicts.append(get_row_as_dict(i))
        return list_of_dicts
    


    ## return a dict of dicts, such that the first column serves as a key reference
    func get_keyed_data(primary_key : int = 0):
        
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
    
    ## when loading class, we need to specify the csv filename which will trigger loading
    func _init(_filename: String, max_rows = 1000000):
        self._filename = _filename
        _load_filename(_filename,max_rows)
    
 
    
