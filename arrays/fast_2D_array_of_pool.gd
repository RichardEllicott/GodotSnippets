


class TwoDimensionalArray:
    
    """
    
    wrap a PoolRealArray to behave like a 2D array
    
    works like a 2D array of 32bit floats (warning Godot normally uses 64bit)
    
    
    WARNING, before filling the cells, they will be full of garbage
    it saves time to not bother clearing them and wait until we set them manually
    
    alternativly i included a "clear" function to set them to zero
    
    """

    
    var pool : PoolRealArray
    
    var _width : int
    var _height : int
    
    func _get_cell_ref(x : int, y : int) -> int:
        
        assert(x < _width)
        assert(y < _height)
        
        return x + (y * _width)
    
    func get_cell(x : int, y : int) -> float:
        return pool[_get_cell_ref(x,y)]
        
    func set_cell(x : int, y : int, val : float):
        pool[_get_cell_ref(x,y)] = val
        
    func clear(default_value : float = 0.0):
        for y in _height:
            for x in _width:
                set_cell(x,y,default_value)
        
    
    func _init(width = 16, height = 16):
        pool = PoolRealArray() # create a new pool
        pool.resize(width*height) # set it's size in advance (warning garbage data now present)
        
        _width = width # height and width saved to private vars for later usage
        _height = height
