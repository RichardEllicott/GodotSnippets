"""
library name: "PathFindD"

last update: 18/01/2023 Richard Ellicott


this is a grid based pathfind similar to Dijkstra's algo

vs A*?

-Dijkstra's algo is the same as A* without the optimisation.
-A* is better in large sparesly populated tilemaps where we know the target direction.
-Dijkstra is more flexible as it could search for the first predicate result (i.e closest apple)
-Dijkstra also can be customised with more advanced rules still, like following tunnels, teleports etc

we built the pathfind as encapsulated classes due to complexity issues preventing code reuse:

PathFindD.PathFinder(tilemap: TileMap) # 2D code, works, should be refactored to use all Vector2s (still bugs)
PathFindD.PathFinder3D(gridmap: GridMap) # 3D version, now working



new version builds a "flowmap"
the squares are filled with a translation reference, usually 0-3 for -z,+x,+z,-x or N,E,S,W
following this translation backwards provides the path of the flowmap (all flowing backwards)


"""
#tool
extends Node
class_name PathFindD # class called PathFindD, to avoid confusion



class PathFinder:
    """
    pathfind object
    
    a TileMap version of Dijkstra's algorithm
    
    imported from old code circa 18/01/2023

    """
    
    var tile_map : TileMap
    
    var from: Vector2 = Vector2(0,0)
    var to: Vector2 = Vector2(4,4)
    
    var debug_tile_map : TileMap
    
    var max_checks : int = 10000 # max total checks
    var max_range: int = 10000 # max range
    
    var trim_cardinal_positions = true
    
    var current_translations = [
        [0,-1], #N
        [1,0], #E
        [0,1], #S
        [-1,0], #W
#        [1,-1], #NE
#        [1,1], #SE
#        [-1,1], #SW
#        [-1,-1], #NW
       ]
    
    func _sucess_predicate (x,y,tile_val):
        """
        return true to confirm we have reached our target breaking the loop
        """
        var target_x = int(to.x)
        var target_y = int(to.y)
        
        return x == target_x and y == target_y # reached target destination

    var block_mode = 0

    func _cell_is_unblocked(x,y):
        """
        predicate to check if a cell is unblocked
        """
        match block_mode:
            0:
                return tile_map.get_cell(x,y) == -1 # rules for na empty
            1:
                return tile_map.get_cell(x,y) != -1 # rules for na empty
        
    var flow_map: TileMap # this tilemap is like a flow map showing distance
    
    func pathfind(_from: Vector2, _to: Vector2):
        
        from = _from
        to = _to
        
        var draw_to_debug_tile_map = false
        if is_instance_valid(debug_tile_map):
            draw_to_debug_tile_map = true
            
        var start_x = int(from.x)
        var start_y = int(from.y)

        if not flow_map:
            flow_map = TileMap.new() # map for search data
        flow_map.clear()

        if draw_to_debug_tile_map:
            debug_tile_map.clear()
            debug_tile_map.cell_size = tile_map.cell_size

        var to_search_cells = [] # cells to be checked
    
        to_search_cells.append([start_x,start_y,0]) # seed with start

        var ttl = max_checks # make cells to check

        var sucess = false # sucess in finding target
        var sucess_position
        
        var ret = [] # the final path position result
        
        # floodfill loop, spreads outwards searching for result
        while to_search_cells.size() > 0 and ttl > 0: # why we still have cells we can check
            ttl -= 1
            
            var current_cell = to_search_cells.pop_front()
        
            var x = current_cell[0]
            var y = current_cell[1]
            var n = current_cell[2] + 1 # n is incremented
            
            if n > max_range + 1:
                break
            
            var val = tile_map.get_cell(x,y)
            var unblocked = _cell_is_unblocked(x,y)
            
            if unblocked and _sucess_predicate(x,y,val):
                sucess = true
#                path_positions.append([x,y,n])
                sucess_position = [x,y,n]
                break # if we have sucess, break the loop
            
            # if cell unblocked and flowmap unvisted
            if unblocked and flow_map.get_cell(x,y)  == -1:
                flow_map.set_cell(x,y,n) # mark flowmap
                
                if draw_to_debug_tile_map:
                    debug_tile_map.set_cell(x,y,0)

                for trans in current_translations:
                    to_search_cells.append([x+trans[0],y+trans[1],n]) # N

        if sucess: # if we found target we need to build the sequence
            
            # unused
            var path_positions_vec = PoolVector2Array()
            path_positions_vec.resize(sucess_position[2])
            path_positions_vec[sucess_position[2]-1] = Vector2(sucess_position[0],sucess_position[1])
            
            # used
            var path_positions_blocks = []
            path_positions_blocks.resize(sucess_position[2])
            path_positions_blocks[sucess_position[2]-1] = [sucess_position[0],sucess_position[1]]
            
            var current_pos = sucess_position
                    
            ttl = 1000
            while ttl > 0:
                ttl -= 1

#                current_pos = path_positions.back()
                var x = current_pos[0]
                var y = current_pos[1]
                var n = current_pos[2]

                if n == 1: # found last cell
                    break

                for trans in current_translations: # for each direction
                    if flow_map.get_cell(x+trans[0],y+trans[1]) == n - 1: # find the cell with 1 lower value
                        
                        var entry = [x+trans[0],y+trans[1],n - 1]
                        
                        current_pos = entry
                        
                        
                        path_positions_vec[n-2] = Vector2(entry[0],entry[1]) # we don't use yet                        
                        path_positions_blocks[n-2] = [entry[0],entry[1]]
                        
                        break
                        
#            print("path_positions2:",path_positions_vec)
#            path_positions_vec = _trim_cardinal_positions_vector(path_positions_vec)
#            print("path_positions2:",path_positions_vec)
            
            ret = path_positions_blocks

        if draw_to_debug_tile_map:
            for pos in ret:
                debug_tile_map.set_cell(pos[0],pos[1],1)
            debug_tile_map.set_cell(from.x,from.y,5)

        if trim_cardinal_positions:
            _trim_cardinal_positions(ret)
            
        if draw_to_debug_tile_map:
            for pos in ret:
                debug_tile_map.set_cell(pos[0],pos[1],2) # shows a different result if we have trimmed path positions
                
        search_path = ret
        return ret
                
    static func _trim_cardinal_positions(path_positions: Array) -> void:
        """
        trim path positions that share the same x or y values
        
        reduces the path positions if the path goes in a straight line
        
        WARNING: modifies target array
        """

        var continuous_x_run = 0
        var continuous_y_run = 0

        #HACKY!, add dummy position
        path_positions.push_front([null,null])

        var last_x # last x we checked
        var last_y

        var n = path_positions.size()

        while n > 0: # we iterate backwards to allow deleting while we go
            n -= 1
            var pos = path_positions[n]
    #        print("path_positions ", n, " ", pos)
            if last_x == pos[0]: # last pos on same x
                continuous_x_run += 1
            else:
                if continuous_x_run > 0: # means we have a run
    #                    print('continuous_x_run: ', continuous_x_run)
                    for n2 in continuous_x_run - 1:
                        path_positions.remove(n+2) # note we delete two positions back from this point
                    continuous_x_run = 0

            if last_y == pos[1]: # last pos on same y
                continuous_y_run += 1
            else:
                if continuous_y_run > 0: # means we have a run
    #                    print('continuous_y_run: ', continuous_y_run)
                    for n2 in continuous_y_run - 1:
                        path_positions.remove(n+2) # note we delete two positions back from this point
                    continuous_y_run = 0

            last_x = pos[0]
            last_y = pos[1]

        path_positions.pop_front() # remove dummy position

    static func _trim_cardinal_positions_vector(path_positions: Array) -> Array:
        
        var ret = __trim_cardinal_positions_vector(path_positions, 0)
        ret = __trim_cardinal_positions_vector(path_positions,1)
        
        return ret
        
    static func __trim_cardinal_positions_vector(path_positions: Array, axis: int = 0) -> Array:
        """
        trim path positions that share the same x or y values
        
        reduces the path positions if the path goes in a straight line
        
        WARNING: modifies target array
        """
        var ret = []
        
        var last_pos = Vector2(268736,3823793)
        
        var in_run = false
        var run_count = 0
        
        for pos in path_positions:
            
            var predicate = pos.x == last_pos.x
            
            if axis == 1:
                predicate = pos.y == last_pos.y
                
            if predicate:
                if not in_run:
                    ret.append(pos)
                    run_count = 1
                    pass # START RUN
                in_run = true
                run_count += 1
            else:
                if in_run:
                    in_run = false # END RUN
                    run_count = 0
                    ret.append(last_pos) # we add last pos when run ends
            

                
            last_pos = pos
            
            if not in_run:
                ret.append(pos)
                
                    
        return ret
    
    var search_path

    func set_curve_points(curve: Curve2D) -> void:
        curve.clear_points()
        var cell_size = tile_map.cell_size
        for pos in search_path:
            curve.add_point(Vector2(
                pos[0] * cell_size.x + cell_size.x / 2.0,
                pos[1] * cell_size.y + cell_size.y / 2.0))
        
    var _island_scan_cache_tilemap

    func island_scan():
        """
        scan for seperate islands, isolated parts of the map
        """
        
        block_mode = 1 # hack, only works in this mode
        
        var debug = false
        if is_instance_valid(debug_tile_map):
            debug = true
            
        var search_ttl = 1000
            

#        print("island_scan()...")

        if not _island_scan_cache_tilemap:
            _island_scan_cache_tilemap = TileMap.new()
        var search_cell_tile_map = _island_scan_cache_tilemap # map for search data
        search_cell_tile_map.clear()

        var used_cells = tile_map.get_used_cells() # we try floodfill on all used cells

        var island_count = 0


        if debug and is_instance_valid(debug_tile_map):
            debug_tile_map.clear()
            debug_tile_map.cell_size = tile_map.cell_size

        var ttl = search_ttl * 128 # make cells to check
        
        
        var island_ref_pos_dict = {}
        var island_ref_pos_list = []
        
        
        for start_cell in used_cells:

            var island_size_count = 0

            var to_search_cells = [] # cells to be checked

            to_search_cells.append([int(start_cell.x),int(start_cell.y),0]) # seed with start

            while to_search_cells.size() > 0 and ttl > 0:
                ttl -= 1

                var current_cell = to_search_cells.pop_front()

                var x = current_cell[0]
                var y = current_cell[1]

                var n = current_cell[2] + 1

                var cell_val = tile_map.get_cell(x,y)
                var search_cell_val = search_cell_tile_map.get_cell(x,y)

                if search_cell_val == -1:
                    island_size_count += 1



                if _cell_is_unblocked(x,y) and search_cell_val  == -1:
                    
                    if not island_count in island_ref_pos_dict:
                        island_ref_pos_dict[island_count] = Vector2(x,y)

                    search_cell_tile_map.set_cell(x,y,island_count)
                    if debug:
                        debug_tile_map.set_cell(x,y,island_count)

                    for trans in current_translations:
                        to_search_cells.append([x+trans[0],y+trans[1],n]) # N

            if island_size_count > 0:
                island_count += 1
                print("found island %s size: %s" % [island_count,island_size_count])
                
#                var _island_ref_pos_dict = island_ref_pos_dict
#                island_ref_pos_dict = []
#                for key in _island_ref_pos_dict:
#                    island_ref_pos_dict.append(_island_ref_pos_dict[key])
                
                print(island_ref_pos_dict)
                
                
                for key in island_ref_pos_dict:
                    island_ref_pos_list.append(island_ref_pos_dict[key])
                    
                print(island_ref_pos_list)
                    
        return search_cell_tile_map # maybe use this
        
    func _init(_tile_map : TileMap):
        
        tile_map = _tile_map
        
class PathFinder3D:
    """
    now based on flowmap, code reuse maximum
    
    most of these functions interact with this class, so calling 
    
    
    """

    var grid_map: GridMap
    
    
    var from: Vector3 = Vector3(0,0,0)
    var to: Vector3 = Vector3(4,0,4)
    
    var debug_grid_map : GridMap
    
    var max_checks : int = 1000 # max total checks
    var max_range: int = 1000 # max range

    var shave_paths = true # shave the paths down when their are runs of the same direction reducing the coordinates returned
    
    # valid translations for pathfind movement, could support knight moves etc but normal is just N,E,S,W
    var translations = [
            Vector3(0,0,-1), # N -z
            Vector3(1,0,0), # E +x
            Vector3(0,0,1), # S +z
            Vector3(-1,0,0), # W -x
       ]
    
    var orientations = [0,22,10,16] # orietnations for N,E,S,W rotations
    
    var flow_map: GridMap = GridMap.new() # the flow map is used to perform the flood fill like iteration
    var flow_map_reached_target = false # we have returned true from the _sucess_predicate, found our target
    var flow_map_count = 0 # used to track the tiles checked
    
    # build a flow map, used by all the functions, a map of valid translations (backwards(
    func build_flow_map(_from: Vector3, _to: Vector3 = Vector3(9999,9999,9999)):
        """
        fills the flowmap (GridMap of translations), used for pathfind, island search and also just making a flowmap
        
        when a valid translation is found it is store as the cell item, so usually 0-3 is stored as a var (N,E,S,W)
        
        to find the path back, we follow the translations backwards.
        
        this pathfind method actually supports knight moves etc, not that they're much use
        
        """
        
        assert(is_instance_valid(grid_map)) # there should be no way this is empty
        
        flow_map_reached_target = false
        
        from = _from
        to = _to
        
        var draw_to_debug_grid_map = false
        if is_instance_valid(debug_grid_map):
            draw_to_debug_grid_map = true
            

        if draw_to_debug_grid_map:
            debug_grid_map.clear()
            debug_grid_map.cell_size = grid_map.cell_size

        var to_search_cells = [] # cells to be checked
    
        to_search_cells.append(from) # seed with start

        var ttl = max_checks # make cells to check

        var sucess = false # sucess in finding target
        var sucess_position
        
        var ret = [] # the final path position result
        
        # floodfill loop, spreads outwards searching for result
        while to_search_cells.size() > 0 and ttl > 0: # why we still have cells we can check
            ttl -= 1
            
            flow_map_count += 1
    
            var cell = to_search_cells.pop_front()
#            var current_cell_val = grid_map.get_cell_item(cell.x,cell.y,cell.z)
            
            
            if build_island_map: # extra island map feature, creates a cache of tile to island ref
                island_map.set_cell_item(cell.x,cell.y,cell.z,island_map_set_ref22)
            
            if _sucess_predicate(cell): # if this cell is our target, break loop
                sucess = true
                flow_map_reached_target = true
                break
                  
            for i in translations.size(): # check each possible translation
                
                var check_cell = cell + translations[i] # cell to check
                
                if flow_map.get_cell_item(check_cell.x,check_cell.y,check_cell.z) == -1: # cell hasn't already been marked
                    if _cell_is_unblocked(check_cell): # is passable

                        flow_map.set_cell_item(check_cell.x,check_cell.y,check_cell.z,i) # we save a ref of the translation
                        to_search_cells.append(check_cell)
                    
                        if draw_to_debug_grid_map: # mark debug map, note how 
                            # the default direction (0) is N which is -z
                            # 1 is E, +x
                            # 2 is S, +z
                            # 3 is W, -x
                            debug_grid_map.set_cell_item(check_cell.x,check_cell.y,check_cell.z,3,orientations[i])
            
        if draw_to_debug_grid_map:
            debug_grid_map.set_cell_item(from.x,from.y,from.z,1) # mark start position
#            debug_grid_map.set_cell_item(from.x,from.y,from.z,1)

        return flow_map
        
        
        



    # perform a pathfind, will return a path as a list, will use the flowmap function
    func pathfind(_from: Vector3, _to: Vector3) -> Array:
        
        clear() # clear previous data, the flowmap may be already filled
        
        from = _from
        to = _to
        
        flow_map_reached_target = false
        
        if not _cell_is_unblocked(from): # return null in these scenarios
            return []
        if not _cell_is_unblocked(to):
            return []
            
        var draw_to_debug_grid_map = false
        if is_instance_valid(debug_grid_map):
            draw_to_debug_grid_map = true
                    
        build_flow_map(from,to) # build flowmap puts variables on the class body
        
        var path = [] #  will result in backwards path
        
        if flow_map_reached_target:
            
            var cell = to # current cell

            path.append(to)
            
            for i in 1000:
                var flow_dir = flow_map.get_cell_item(cell.x,cell.y,cell.z)
            
                cell = cell - translations[flow_dir] # we use the translations backwards
                path.append(cell)
                
                if draw_to_debug_grid_map:
                    debug_grid_map.set_cell_item(cell.x,cell.y,cell.z,1,orientations[flow_dir])
                
                if cell == from: # if we have reached to, then break
                    break


        if shave_paths:
            var last_item = -1000
            var new_path = []
            for cell in path:
                var item = flow_map.get_cell_item(cell.x,cell.y,cell.z)
                if item != last_item:
                    new_path.append(cell)
                last_item = item
                
            new_path.append(from)
            
            if draw_to_debug_grid_map:
                for cell in new_path:
                    # draw a new color to show the path turns
                    debug_grid_map.set_cell_item(cell.x,cell.y,cell.z,4,
                        debug_grid_map.get_cell_item_orientation(cell.x,cell.y,cell.z))
        
            path = new_path # overwrite the path with the shorter one
            
        
        ## mark start and finish color (do not change orientation)
        if draw_to_debug_grid_map:
            debug_grid_map.set_cell_item(from.x,from.y,from.z,0,
                debug_grid_map.get_cell_item_orientation(from.x,from.y,from.z)
            ) # mark start position
            debug_grid_map.set_cell_item(to.x,to.y,to.z,2,
                debug_grid_map.get_cell_item_orientation(to.x,to.y,to.z)
            )


        # reverse the list and turn into PoolVector3Array
        var count = path.size()
        var ret = PoolVector3Array()
        ret.resize(count)
        for i in count:
            ret[count - i - 1] = path[i]            
        return ret
        
    func _init(_grid_map : GridMap):
        grid_map = _grid_map
    
    # check for islands, which are unconnected groups of valid tiles
    # used to find seperate road networks etc
    
    var build_island_map: bool = false # if true, build an island map
    var island_map: GridMap = GridMap.new()
    var island_map_set_ref22: int = 0
    
    func island_search():
        """
        return a list of island positions, islands are groups of connected tiles, for example road networks not joined
        
        the list returns will contain one coordinate from each island, so the island can be found
        """
        
#        print("island_search...")
        
        build_island_map = true
        island_map.clear()
        island_map_set_ref22 = 10
        
        
        var draw_to_debug_grid_map = false
        if is_instance_valid(debug_grid_map):
            draw_to_debug_grid_map = true
        
        
        var island_positions = []
        var island_sizes = []
        
        for cell in grid_map.get_used_cells():
            
            var item = grid_map.get_cell_item(cell.x,cell.y,cell.z)
            var check_flow_map = flow_map.get_cell_item(cell.x,cell.y,cell.z)

            if check_flow_map == -1 and item in _get_valid_tiles():  # unchecked and valid tile
                  
                var island_size = flow_map_count # save the current flow map count, to work out how many tiles are checked
                
                build_flow_map(cell) # build flow map from here, this will fill out the flow map with values != -1
                
                island_size = flow_map_count - island_size - 1 # the size seems to be one less (quirk? test?)
                
                island_positions.append(cell) # save this position as it's a valid island position
                
                island_sizes.append(island_size)

                
                island_map_set_ref22 += 1
        
        if draw_to_debug_grid_map:
            for i in island_positions.size():
                var cell = island_positions[i]
                debug_grid_map.set_cell_item(cell.x,cell.y,cell.z,i)
        
        
        if true and draw_to_debug_grid_map:
            
            var used_cells = island_map.get_used_cells()
            print("used_cells.size(): ", used_cells.size())
            
            for cell in used_cells:
                var item = island_map.get_cell_item(cell.z,cell.y,cell.z)
                
                
                print("set item: ", item)
                debug_grid_map.set_cell_item(cell.x,cell.y,cell.z,item)
#                debug_grid_map.set_cell_item(cell.x,cell.y,cell.z,1)
            
            pass
                        
        build_island_map = true
        
        return island_positions
        
    # reset this object state, since some functions leave state variables on this class body
    func clear():
        flow_map.clear()
        flow_map_reached_target = false
        flow_map_count = 0


    # convert a list of names to id's
    # warning only needs to begin with the name, ie "road" will match "road_0","road_1" etc...
    static func tile_names_to_ids(mesh_library: MeshLibrary, names: Array) -> Array:
        var ids = []
        for id in mesh_library.get_item_list():
            var item_name = mesh_library.get_item_name(id) # get the names
            for _name in names:
                if item_name.begins_with(_name):
                    ids.append(id)
                    break
        return ids
           
        
    
    ## overriding these functions changes the behaviour of the pathfinder
    
    # return a list of the valid tiles (ones our pathfind is not blocked by)
    func _get_valid_tiles() -> Array:
        return [-1]
        
    # returns true if cell unblocked
    # can override this predicate
    func _cell_is_unblocked(position: Vector3) -> bool:      
        return grid_map.get_cell_item(position.x,position.y,position.z) in _get_valid_tiles()
        
    # returns true when we meet the conditions to end our search, normally this just matches the "to" as we have reached a destination
    # could be replaced with custom behaviour
    func _sucess_predicate (position: Vector3):
        return position == to
        

    func snake_search(_from = Vector3(-16,0,0), max_steps = 32, max_results = 128) -> Array:
        """
        simple search pattern that makes a spiral out from a position, this allows a rough query of the nearest items in a rough order
        
        returns a lists of results that matched the _sucess_predicate, the _sucess_predicate must be set up correctly
        
        the search pattern, taking N as -z and E as +x is:
            N1 E1 S2 W2 N3 E3 S4 W4 ...
            
        usages are things like a quick near check, for example an electricity pylon wants to find the nearest other pylon to set up the cables
        """
        # a very simple search that searches a 2D spiral around the target square, it will return a list of all predicate matches
        # can be used to make a simple closest item search that does not pathfinding
        # snake search operates like:
        # N1 E1 S2 W2 N3 E3 S4 W4 ...

        # supports debug data (this can illustrate the search pattern)
        var draw_to_debug_grid_map = false
        if is_instance_valid(debug_grid_map):
            draw_to_debug_grid_map = true
            debug_grid_map.clear()
        
        var results = [] # results of the  _sucess_predicate 
        
        var cell: Vector3 = _from # our "pen position"
        
        for i in max_steps:
            var trans = translations[i % 4] # the translations must be [N,E,S,W] (-z,+x,+z,-x) to work
            
            var steps = (i / 2) + 1 # 1,1,2,2,3,4,4...
            
            for i2 in steps: # steps to move forward
                if _sucess_predicate(cell):
                    results.append(cell)
                    if results.size() >= max_results:
                        return results

                if draw_to_debug_grid_map:
                    debug_grid_map.set_cell_item(cell.x,cell.y,cell.z,(steps-1)%6,orientations[i%4])
                
                cell += trans # move our position
                  
        return results
    
    
    func shell_search(_from = Vector3(-16,0,0),  var shell_count = 4, max_results = 128):
        """
        there seems to be no logical snake search in 3D
        
        simple alt is "shell search" (orginal name)
        
        checks increasing cube shells around a square, for matching nearest results but now in 3D
        
        if results need to be the same height, use the faster snak search
        
        """
        
        var results = []
        
        var draw_to_debug_grid_map = false
        if is_instance_valid(debug_grid_map):
            draw_to_debug_grid_map = true
            debug_grid_map.clear()
        
        var checked_cells = {} # already checked cells
        
        for shell_i in shell_count:
            
            var origin = Vector3(1,1,1) * -shell_i # the origin of the new cube
            
            var width = shell_i * 2 + 1 # 1,3,5,7,9...
            
            for y in width:
                for z in width:
                    for x in width:
                        
                        var cell = origin + Vector3(x,y,z)
                        
                        if not cell in checked_cells: # if have not already checked this cell
                            if _sucess_predicate(cell):
                                results.append(cell)
                                if results.size() >= max_results:
                                    return results
                            
                            if draw_to_debug_grid_map:
                                debug_grid_map.set_cell_item(cell.x,cell.y,cell.z,shell_i%6)
                        
                        checked_cells[cell] = true
            
        return results
    
    
    
    
        
    # these draw functions move elsewhere?
    static func get_mesh_library_ref_to_name(mesh_library: MeshLibrary):
        var keys = {}
        for i in mesh_library.get_item_list():
            var val = mesh_library.get_item_name(i)    
            keys[i] = val
        return keys
        
    static func get_mesh_library_name_to_ref(mesh_library: MeshLibrary):
        var keys = {}
        for i in mesh_library.get_item_list():
            var val = mesh_library.get_item_name(i)    
            keys[val] = i 
        return keys
    
        
    # test draw functions?
    var _set_cell_cache
    func set_cell(_grid_map: GridMap, x: int, y: int, z: int, item, orientation: int = 0):
        if not _set_cell_cache:
            _set_cell_cache = get_mesh_library_name_to_ref(grid_map.mesh_library)
        if item is String:            
            item = _set_cell_cache[item]
        assert(item is int)
        _grid_map.set_cell_item(x,y,z,item,orientation)
    
    var _get_cell_cache
    func get_cell(_grid_map: GridMap, x: int, y: int, z: int):
        if not _get_cell_cache:
            _get_cell_cache = get_mesh_library_ref_to_name(grid_map.mesh_library)
        var ret = _grid_map.get_cell_item(x,y,z)
        ret = _get_cell_cache[ret]
        return ret
        
        
class PathFinder3D_SnakeSearch extends PathFinder3D:


    func _init(_grid_map: GridMap).(_grid_map): # this odd godot syntax calls parent constructor, kinda cool as we can cool init above us
        pass
        
    var target_tiles: Array = ["road_"]
#    var valid_tiles: Array = ["rail_", "road_6"]
    var _target_tiles: Array
    func _get_target_tiles() -> Array:
        if not _target_tiles:
            _target_tiles = tile_names_to_ids(grid_map.mesh_library, target_tiles)
        return _target_tiles
    
    # sucess if tile in valid tiles (for snake search)
    func _sucess_predicate (position: Vector3):
        
        var item = grid_map.get_cell_item(position.x,position.y,position.z) 
         
        return item in _get_target_tiles()
        


            
class PathFinder3D_Car extends PathFinder3D:
    """
    classes seem to mess up inti
    
    """

    func _init(_grid_map: GridMap).(_grid_map): # this odd godot syntax calls parent constructor, kinda cool as we can cool init above us
        pass
    
    
    var valid_tiles: Array = ["road_"]
#    var valid_tiles: Array = ["rail_", "road_6"]
    var _valid_tiles: Array
    func _get_valid_tiles() -> Array:
        if not _valid_tiles:
            _valid_tiles = tile_names_to_ids(grid_map.mesh_library, valid_tiles)
        return _valid_tiles
    
class PathFinder3D_Rail extends PathFinder3D:
    """
    classes seem to mess up inti
    
    """

    func _init(_grid_map: GridMap).(_grid_map): # this odd godot syntax calls parent constructor, kinda cool as we can cool init above us
        pass
    
    
#    var valid_tiles: Array = ["road_"]
    var valid_tiles: Array = ["rail_", "road_6"]
    var _valid_tiles: Array
    func _get_valid_tiles() -> Array:
        if not _valid_tiles:
            _valid_tiles = tile_names_to_ids(grid_map.mesh_library, valid_tiles)
        return _valid_tiles

class PathFinder3D_EXTENDED extends PathFinder3D:
    """
    classes seem to mess up inti
    
    """

    func _init(_grid_map: GridMap).(_grid_map): # this odd godot syntax calls parent constructor, kinda cool as we can cool init above us
        pass
    
class GridMapLogicTest:
    
    var grid_map: GridMap
    var pathfinder: PathFinder3D

    var ref_to_name: Dictionary
    var name_to_ref: Dictionary
    
    var translations = [
            Vector3(0,0,-1), # N -z
            Vector3(1,0,0), # E +x
            Vector3(0,0,1), # S +z
            Vector3(-1,0,0), # W -x
       ]
    
    var orientations = [0,22,10,16] # orietnations for N,E,S,W rotations (assuming object faces -z for north)
    # extra
    # 4 UP
    # 12 DOWN
    
    
    
    func _init(_grid_map : GridMap):
        
        print("GridMapLogicTest...")
        
        grid_map = _grid_map
        pathfinder = PathFinder3D_Car.new(grid_map)

        assert(grid_map.mesh_library) # must have a mesh_library
        ref_to_name = {}
        name_to_ref = {}
        if grid_map.mesh_library:
            for i in grid_map.mesh_library.get_item_list():
                var item = grid_map.mesh_library.get_item_name(i)   
                ref_to_name[i] = item
                name_to_ref[item] = i
                
        test()
    
    
    class BusStop:
        
        pass
    
    var bus_stops = []
    
    func test():
        
        var AGENTS = Tools.get_or_create_child(grid_map,"AGENTS",Spatial)
        
        var ref = name_to_ref['bus_stop']
        
        for cell in grid_map.get_used_cells_by_item(ref):
            
            var orientation = grid_map.get_cell_item_orientation(cell.x,cell.y,cell.z)
            assert(orientation in orientations)
            
            var i = orientations.find(orientation)
            print(cell)
            print("NESW"[i])
            
            var offset = cell + translations[i]
            
#            print(grid_map.get_cell_item(offset.x,offset.y,offset.z))
        
            var is_unblocked = pathfinder._cell_is_unblocked(offset)
 
class Tools:
    
    ## create a child of the parent if it doesn't already exist, return a reference
    ## eg:
    ## var some_node = Tools.get_or_create_child(grid_map,"NodeName",Spatial)
    ## new static version
    static func get_or_create_child(parent: Node,node_name: String, node_type = Node) -> Node:        
        var node = parent.get_node_or_null(node_name) # get the node if present
        if not is_instance_valid(node): # if no node found make one
            node = node_type.new()
            node.name = node_name
            parent.add_child(node)
            node.set_owner(parent.get_tree().edited_scene_root) # show in tool mode
        assert(node is node_type) # best to check the type matches
        return node
        
    # save dict to json files
    static func save_to_json_file(path : String, content : Dictionary, pretty: bool = true):
        """
        https://github.com/RichardEllicott/GodotSnippets/blob/master/code_patterns/save_data_bin_txt_json.gd
        """
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
        """
        https://github.com/RichardEllicott/GodotSnippets/blob/master/code_patterns/save_data_bin_txt_json.gd
        """
        var file: File = File.new()
        var err: int = file.open(path, File.READ)
        if err != OK:
            # https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#enum-globalscope-error
            push_error("failed to open file at: \"%s\"\nerror code: %s" % [path,err])
        var content: Dictionary = parse_json(file.get_as_text())
        file.close()
        return content
    
    
        # create a 32bit int from the string of a variable
    # works with Vector3 for instance to create unique hash
    static func string_hash(hash_me, _bytes: int = 4):
        ## 32 bits need 4 bytes, 8 chars
        var ret = "0x%s" % String(hash_me).sha256_text().substr(0,_bytes * 2) # create a hex string
        ret = ret.hex_to_int() # convert to 32 bit
        return ret

class GridMapSerialize:
    """
    serialize/deserialize to/from a json compatible dictionary 
    
    quickly save a map like
    
    var gm_serialize = GridMapSerialize.new(grid_map) # make this object with a link to gridmap
    gm_serialize.save_to_file(filename) # call save function
    
    
    when saving a tilemap with this method, it also saves the keys in the json so requires the correct mesh_library
    however when loading, using these keys it uses them as the id if possible
    
    this means when a meshlib changes ids, this will still reload the map
    
    """
    var grid_map: GridMap
    
    var ref_to_name: Dictionary
    var name_to_ref: Dictionary
    
    func _init(_grid_map : GridMap):
        grid_map = _grid_map
        assert(grid_map.mesh_library) # must have a mesh_library
        ref_to_name = {}
        name_to_ref = {}
        if grid_map.mesh_library:
            for i in grid_map.mesh_library.get_item_list():
                var item = grid_map.mesh_library.get_item_name(i)   
                ref_to_name[i] = item
                name_to_ref[item] = i
        
        
    func serialize() -> Dictionary:
        """
        warning serialize_gridmap doesn't have the meta data deserialize_gridmap has
        
        convert gridmap to serial array:
            [x1,y1,z1,item1,orientation1,x2,y2,z2,item2,orientation2...]
        
        """
        var ret = {}
        
        var layout = [] # the map data serializes into one long list of ints
        var used_cells = grid_map.get_used_cells()
        layout.resize(used_cells.size() * 5) # the return array is the entries x5 long
        
        for i in used_cells.size():
            var cell = used_cells[i]
            var i2 = i * 5
            layout[i2] = cell.x
            layout[i2+1] = cell.y
            layout[i2+2] = cell.z
            layout[i2+3] = grid_map.get_cell_item(cell.x,cell.y,cell.z)
            layout[i2+4] = grid_map.get_cell_item_orientation(cell.x,cell.y,cell.z)
            
        ret['layout'] = layout
        ret['keys'] = ref_to_name
        
        return ret
        

    func deserialize(load_data: Dictionary) -> void:
        
        var keys = load_data['keys'] # warning, the keys will go to strings from the json
        var layout = load_data['layout']
        
        var this_keys = {}
        for v in grid_map.mesh_library.get_item_list():
            this_keys[v] = grid_map.mesh_library.get_item_name(v)
        
        for i in layout.size()/5: # array will be in chunks of 5 values per an entry
            
            var i2 = i * 5
            var x = layout[i2]
            var y = layout[i2+1]
            var z = layout[i2+2]
            var item = layout[i2+3]
            var orientation = layout[i2+4]
            
            # this code will attempt to use the string name over the int, this means if a tile changes ref it will still work
            var ref_name = keys[String(item)] # get the orginal name of this entry
            if ref_name in name_to_ref: # if we have a matching name, we will correct the item int to this one       
                item = name_to_ref[ref_name]
            
            grid_map.set_cell_item(x,y,z,item,orientation)
        
    func save_to_file(path):
        Tools.save_to_json_file(path,serialize())

    func load_from_file(path):
        var data = Tools.load_from_json_file(path) 
        deserialize(data)
        


class UsefulData:
    
    var translations = [
            Vector3(0,0,-1), # N -z
            Vector3(1,0,0), # E +x
            Vector3(0,0,1), # S +z
            Vector3(-1,0,0), # W -x
       ]
    
    var orientations = [0,22,10,16] # orietnations for N,E,S,W rotations
    
    # 8 offsets for directions on compass
    var translations8 = [
        Vector3(0,0,-1), # N -z
        Vector3(1,0,-1), # NE
        Vector3(1,0,0), # E +x
        Vector3(1,0,1), # SE
        Vector3(0,0,1), # S
        Vector3(-1,0,1), # SW
        Vector3(-1,0,0), # W
        Vector3(-1,0,-1), # NW
       ]
    
    static func get_offset_list():
        # this list is from top to bottom, from NW going E
        # then going south in layers
        # this makes the first layer (9) all below
        # the next layer is level, so it has the 8 compass directions
        # the next layer is up
        var offset_list = []
        for y in 3:
            for z in 3:
                for x in 3:
                    offset_list.append(Vector3(x-1,y-1,z-1))
        return offset_list


class Scratch:
    
    func _init():
        print("run Scratch...")
        test()
        
        
    func gen_egg_shell():
        # might be a useful search pattern, for searching with no blocks
        print("gen_egg_shell...")
        
        var shell = []
        
        var shell_count = 4
        
        for shell_i in shell_count:
            
            var origin = Vector3(1,1,1) * -shell_i
            
            var width = shell_i * 2 + 1
            
            print(origin)
            print(width)
            
#            for y in width:
#
#                if y == 
#
#                for z in width:
#                    for x in width:
#
#                        pass
            
        
        

    func test():
        
        # explains the orientation
        #https://stackoverflow.com/questions/67443086/gridmap-node-set-cell-item-rotation-of-the-tile-object
        
        var transforms = UsefulData.get_offset_list()
                    
                    
        var match_dict = {}
        match_dict[Vector3(0,0,-1)] = "N"
        match_dict[Vector3(1,0,0)] = "E"
        match_dict[Vector3(0,0,1)] = "S"
        match_dict[Vector3(-1,0,0)] = "W"
        
        match_dict[Vector3(1,0,-1)] = "NE"
        match_dict[Vector3(1,0,1)] = "SE"
        match_dict[Vector3(-1,0,1)] = "SW"
        match_dict[Vector3(-1,0,-1)] = "NW"
        
        
        for i in transforms.size():
            var trans: Vector3 = transforms[i]
            
            var s: String = ""
            s += String(trans)
            if trans in match_dict:
                s += " %s" % String(match_dict[trans])
                
            s = "%s: %s" % [i,s]
            
            s += " %s" % Tools.string_hash(trans)
                
            print(s)
            
        gen_egg_shell()
        
        


# EXAMPLES

func pathfind_funct(grid_map: GridMap, _from: Vector3, _to: Vector3):
    
    
    
    
    
    
    pass
            
        
