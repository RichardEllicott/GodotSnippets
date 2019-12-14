func flood_fill(tile_map,x,y,val, ttl = 1000):
    """
    flood fill a tile map like on paint

    note the ttl as tilemaps are infinite
    """
    var start_val = tile_map.get_cell(x,y)
    if start_val != val:

        var cells_to_check = [[x,y]] # add cells like [x,y]
        while cells_to_check.size() > 0 and ttl > 0:
            ttl -= 1
            var current_cell = cells_to_check.pop_front()
            var x2 = current_cell[0]
            var y2 = current_cell[1]
            var current_cell_val = tile_map.get_cell(x2,y2)

            if current_cell_val == start_val:
                tile_map.set_cell(x2,y2, val)

                cells_to_check.append([x2,y2-1]) # N
                cells_to_check.append([x2+1,y2]) # E
                cells_to_check.append([x2,y2+1]) # S
                cells_to_check.append([x2-1,y2]) # W