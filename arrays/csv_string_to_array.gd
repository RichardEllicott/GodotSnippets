"""

convert a string like:

  0,0,0,0
  0,1,1,0
  0,0,1,0
  0,0,0,0
  
  
quickly to an array of arrays like

[
[0,0,0,0]
[0,1,1,0]
[0,0,1,0]
[0,0,0,0]
]

"""


static func csv_string_to_array_map(map_string: String) -> Array:
    """
    input string like:
        
        0,0,1,0
        0,1,1,0
        0,0,1,0
        
    """
    var ret = []
    var map_split = map_string.strip_edges().split('\n')
    
    for row in map_split:
        
        var new_row = []
        ret.append(new_row)
        var vals = row.split(',')
        
        for val in vals:
            
            val = str2var(val) # convert the strings to vars (warning a blank entry will be a string)
            
            new_row.append(val)
    
    return ret
    
    
