"""
library name: "PathFindD"

last update: 18/01/2023 Richard Ellicott


this is a grid based pathfind similar to Dijkstra's algo

why not A*?

Dijkstra's algo is the same as A* without the optimisation.
A* is better in large sparesly populated tilemaps where we know the target direction.
Dijkstra is more flexible as it could search for the first predicate result (i.e closest apple)
Dijkstra also can be customised to more advanced rules still, like following tunnels, teleports etc



we built the pathfind as encapsulated classes due to complexity issues preventing code reuse:

PathFindD.PathFinder(tilemap: TileMap) # 2D code, works, should be refactored to use all Vector2s (still bugs)
PathFindD.PathFinder3D(gridmap: GridMap) # 3D version, now working


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
            

        print("island_scan()...")

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
    
    var orientations = [0,22,10,16] # orietnations for N,E,S,W (might not match atm)
    

    

        

    
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
            var current_cell_val = grid_map.get_cell_item(cell.x,cell.y,cell.z)
            
            if _sucess_predicate(cell,current_cell_val): # if this cell is our target, break loop
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
    func island_search():
        """
        return a list of island positions, islands are groups of connected tiles, for example road networks not joined
        
        the list returns will contain one coordinate from each island, so the island can be found
        """
        
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

        return island_positions
        
    # reset this object state, since some functions leave state variables on this class body
    func clear():
        flow_map.clear()
        flow_map_reached_target = false
        flow_map_count = 0
        
        
        
    
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
    func _sucess_predicate (position: Vector3, tile_val: int):
        return position == to
        

class PathFinder3D_Car extends PathFinder3D:
    """
    classes seem to mess up inti
    
    """

    func _init(_grid_map: GridMap).(_grid_map): # this odd godot syntax calls parent constructor, kinda cool as we can cool init above us
        pass
    
    
    
    var _valid_tiles: Array
    
#    var valid_tiles: Array = ["road_"]
    var valid_tiles: Array = ["rail_", "road_6"]
    
    func _get_valid_tiles() -> Array:
        
        if not _valid_tiles:
            _valid_tiles = tile_names_to_ids(grid_map.mesh_library, valid_tiles)
        
        return _valid_tiles


    # convert a list of names to id's
    # warning only needs to begin with the name, ie "road" will match "road_0","road_1" etc...
    static func tile_names_to_ids(mesh_library: MeshLibrary ,names: Array) -> Array:
        var ids = []
        for id in mesh_library.get_item_list():
            var item_name = mesh_library.get_item_name(id) # get the names
            for _name in names:
                if item_name.begins_with(_name):
                    ids.append(id)
                    break
        return ids
        


        

            
            
        
        
#
#
#
#    func _init(_grid_map : GridMap):
#
#        grid_map = _grid_map
