"""

there are no 2D arrays in Godot.... however this wrapper shows how to use a PoolArray for an Array basicly as effecient as a 2D array just a bit more ugly


example:
    
var test1 = TwoDimensionalArray.new(4,8)


test1.clear() # call to clear the array of garbage it would start with (for speed it won't clear this automaticly)
test1.set_cell(3,7, 8888)

print(test1.pool)
    
print(test1.get_cell(3,7))

"""


class TwoDimensionalArray:
    
    """
    
    wrap a PoolRealArray to behave like a 2D array
    
    works like a 2D array of 32bit floats (warning Godot normally uses 64bit)
    
    
    WARNING, before filling the cells, they will be full of garbage
    it saves time to not bother clearing them and wait until we set them manually
    
    alternativly i included a "clear" function to set them to zero
    
    """

    
    var pool : PoolRealArray
    
    var _width : int # private vars
    var _height : int
    
    ## return the pool array reference number from (x,y) data
    func _get_cell_ref(x : int, y : int) -> int:
        
        assert(x < _width) # force a crash if out of range query is made, this is better than wacky return data
        assert(y < _height)
        
        return x + (y * _width)
    
    ## return a cell value
    func get_cell(x : int, y : int) -> float:
        return pool[_get_cell_ref(x,y)]
        
    ## set a cell value
    func set_cell(x : int, y : int, val : float):
        pool[_get_cell_ref(x,y)] = val
        
    ## clear all cells by overwiting them (default with 0.0)
    func clear(default_value : float = 0.0):
        for y in _height:
            for x in _width:
                set_cell(x,y,default_value)
    
    ## we require the width and height to build the object
    func _init(width, height):
        pool = PoolRealArray() # create a new pool
        pool.resize(width*height) # set it's size in advance (warning garbage data now present)
        
        _width = width # height and width saved to private vars for later usage
        _height = height
