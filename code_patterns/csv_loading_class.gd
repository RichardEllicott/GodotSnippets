"""

a class to load CSV tables, my existing functions are not suitable for all purposes, based on the Python patterns




"""

class CSV_Table:
    """
    
    class to load a csv file such that the first row is the headers
    
    
    
    """
    
    
    var _filename
    
    var _key_to_col = {} # convert a column name to a column int reference
    
    var header = [] # list of strings from header
    
    var records = [] # list of rows of strings
    
    
    func load_filename(_filename, max_rows = 10):
        
        
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
                
#                print("CSVTABLE: ",row)
                
                if i < start_row: # ignore
                    pass
                elif i == start_row: # header
                    var i2 = 0
                    for val in row:
                        _key_to_col[val] = i2
                        i2 += 1
                    
                    
                    header = row
#                    print("recovered keys: ", keys)
                else: # records
                    
#                    print("%s" % [record_ref], row)
                    
                    
                    records.append(row)
                    
                    record_ref += 1
        
    
    
    func _init(_filename):
        self._filename = _filename
        
        load_filename(_filename)
        
        
        print("CSV_Table record: %s" % [records.size()])
    


    func get_list_of_dicts():
        var ret = []
        
        for record in records:
            
            pass
        
        
        pass


