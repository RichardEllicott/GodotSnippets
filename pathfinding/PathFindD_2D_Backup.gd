
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
   
