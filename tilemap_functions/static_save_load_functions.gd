static func save_to_json_file(path : String, content : Dictionary, pretty: bool = true):
    var file: File = File.new()
    var err: int = file.open(path, File.WRITE)
    if err != OK:
        # https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#enum-globalscope-error
        push_error("failed to open file at: \"%s\"\nerror code: %s" % [path,err])
    if pretty:
        file.store_string(JSON.print(content,"    "))
    else:
        file.store_string(to_json(content))
    file.close()

static func load_from_json_file(path : String) -> Dictionary:
    var file: File = File.new()
    var err: int = file.open(path, File.READ)
    if err != OK:
        # https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#enum-globalscope-error
        push_error("failed to open file at: \"%s\"\nerror code: %s" % [path,err])
    var content: Dictionary = parse_json(file.get_as_text())
    file.close()
    return content
    
static func serialize_tilemap(tilemap: TileMap) -> Array:
    """
    map becomes an array of ints
    each 4 ints represents a cell
    
    [x,y,cell_value,flip_transpose_key]...
    """
    
    var route = 0
    
    var chunk_size: int = 4
    var used_cells: Array = tilemap.get_used_cells()
    var ret: Array = []
    ret.resize(used_cells.size()*chunk_size) # set array size just once
        
    for i in used_cells.size():
        var cell = used_cells[i]
        var val = tilemap.get_cell(cell.x, cell.y)
        
        var i2 = i * chunk_size
        
        ret[i2] = cell.x
        ret[i2+1] = cell.y
        ret[i2+2] = val

        var x_flipped = int(tilemap.is_cell_x_flipped(cell[0],cell[1]))
        var y_flipped = int(tilemap.is_cell_y_flipped(cell[0],cell[1]))
        var transposed  = int(tilemap.is_cell_transposed(cell[0],cell[1]))
        
        match route:
            0:
                var xyt = x_flipped + y_flipped * 10 + transposed * 100
                ret[i2+3] = int(xyt)
            1:
                var xyt = x_flipped + y_flipped * 2 + transposed * 4
                ret[i2+3] = int(xyt)

    return ret
    
static func int_to_bin_string(n: int) -> String:
    """
    int to binary string like "11010110" etc
    165 => "10100101"
    """
    var ret : String = ""
    while n > 0:
        ret = String(n&1) + ret
        n = n>>1
    return ret
    
static func bin_string_to_int(binary_string: String) -> int:
    """
    "10100101" => 165
    """
    var ret = 0
    for i in binary_string.length():
        var pos = binary_string.length() - 1 - i
        match binary_string[pos]:
            '0':
                pass
            '1':
                var e = pow(2,i)
                ret += e
            _:
                assert(false)
    return ret
    
static func deserialize_tilemap(tilemap: TileMap, array: Array) -> int:
    
    # 0 uses decimal keys for the translation (easier to read)
    # 1 uses binary keys for the translation (displayed as an int), like flags
    var route = 0
    
    var chunk_size = 4
    var entry_count = array.size() / chunk_size
        
    for i in entry_count:
        var i2 = i * chunk_size
        var data = [array[i2], array[i2+1], array[i2+2], array[i2+3]]
        
        var x_flipped = false
        var y_flipped = false
        var transposed = false
        
        match route:
            0: # using decimal keys like true,false,true,false => 1010
                var flip_str = "%03d" % (data[3]) # 100 => 0100
                x_flipped = bool(int(flip_str[2]))
                y_flipped = bool(int(flip_str[1]))
                transposed = bool(int(flip_str[0]))
            1: # using bit keys (propper flags)
                var flip_str = int_to_bin_string(data[3])
                
                var pad_me = 3
                if flip_str.length() < pad_me:
                    var add = pad_me - flip_str.length()
                    for i10 in add:
                        flip_str = "0" + flip_str
                                        
                x_flipped = bool(int(flip_str[2]))
                y_flipped = bool(int(flip_str[1]))
                transposed = bool(int(flip_str[0]))
                
        tilemap.set_cell(data[0], data[1], data[2],x_flipped,y_flipped,transposed)
    return 0

static func sha256hex(map_array) -> String:
    return JSON.print(map_array).sha256_text() # use json to make an easy hash

static func map_to_file(tilemap: TileMap, _filename: String) -> void:
    var save_data = {
        'layout': serialize_tilemap(tilemap)
       }
    save_to_json_file(_filename, save_data, false)
    
static func file_to_map(_filename: String, tilemap: TileMap) -> void:
    var data: Dictionary = load_from_json_file(_filename)
    deserialize_tilemap(tilemap, data['layout'])

    
