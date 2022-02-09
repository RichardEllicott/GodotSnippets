"""

there are no 2D arrays in Godot.... however this wrapper shows how to use a PoolArray for an Array basicly as effecient as a 2D array just a bit more ugly


example:
    
var test1 = TwoDimensionalRealArray.new(4,8)


test1.clear() # call to clear the array of garbage it would start with (for speed it won't clear this automaticly)
test1.set_cell(3,7, 8888)

print(test1.pool)
    
print(test1.get_cell(3,7))

"""






class TwoDimensionRealArray:
    
    var pool : PoolRealArray
    
    var width : int # private vars
    var height : int
    
    ## return the pool array reference number from (x,y) data
    func _get_cell_ref(x : int, y : int) -> int:
        
        assert(x < width) # force a crash if out of range query is made, this is better than wacky return data
        assert(y < height)
        
        return x + (y * width)
        
        
    func is_pos_in_range(x,y):
        return x < width and y < height and x >= 0 and y >= 0
    
    ## return a cell value
    func get_cell(x : int, y : int) -> float:
        return pool[_get_cell_ref(x,y)]
        
    ## set a cell value
    func set_cell(x : int, y : int, val : float):
        pool[_get_cell_ref(x,y)] = val
        
    ## clear all cells by overwiting them (default with 0.0)
    func clear(default_value : float = 0.0):
        for y in height:
            for x in width:
                set_cell(x,y,default_value)
    
    ## we require the width and height to build the object
    func _init(width, height):
        pool = PoolRealArray() # create a new pool
        pool.resize(width*height) # set it's size in advance (warning garbage data now present)
        
        self.width = width # height and width saved to private vars for later usage
        self.height = height
