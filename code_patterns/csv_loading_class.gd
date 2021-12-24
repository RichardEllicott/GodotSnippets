"""

a class to load CSV tables, my existing functions are not suitable for all purposes, based on the Python patterns



var x = CSV_Table.new(filename)


"""



class CSV_Table:
    """
    
    class to load a csv file such that the first row is the headers
    
    
    
    """
    
    var _filename # csv filename
    
    var _key_to_col : Dictionary = {} # convert a column name to a column int reference
    
    var header : Array = [] # list of strings from header
    
    var records : Array = [] # list of rows of strings
    
    
    func _load_filename(_filename, max_rows = 92233720368547758):
        """
        loads a filename to this object
            
        filename should be a csv table file with a top row as the header
        """
        
        records = []
        
        var record_ref = 0
        
        var start_row = 0
        self._filename = _filename
        
        _key_to_col = {}
        
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
                    records.append(row)               
                    record_ref += 1
        





    func get_list_of_dicts():
        """
        return the csv table files data as a list of dicts
        """
        var list_of_dicts = [] # retiurn values
        for record in records: # for each record
            var row = {} # build a row
#            print("row: ", row)
#            print("rowsize: ", row.size())
            list_of_dicts.append(row) # append to ret
            for i in header.size(): # for each col
                
                
#                print("header[i]: ", header[i])
#                print("record[i]: ", record[i])
                
                
                
                row[header[i]] = record[i] # assign the value to the dict
        return list_of_dicts

    
    func get_keyed_data(primary_key : int = 0):
        """
        return the data as a dict of dicts, specifying which column to take as the primary key
        
        
        NOT WORKING!!!
        """
        
        var ret = {} # return dict of dicts
        
        
        for rec_ref in records.size(): # for each record
            
            var record = records[rec_ref] # record data as a list
            
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
    
    
    
    func string_to_size(input, size = 8):
        
        
        if input.length() > size:
        
            input = input.substr(0,size-1)
            input += "?"
        
        while input.length() < size:
            input += " "
    
        return input
        
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
        
        
        for row in records:
            
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
            

    func _init(_filename: String, max_rows = 92233720368547758):
        self._filename = _filename
        _load_filename(_filename,max_rows)
    
        
        

