

tile_map = $TileMap


func ran_map(x_start = 0, y_start = 0, x_size = 16, y_size = 16, ran_var = 0.1, _seed = 0):

    var fill_val = 1

    var ran = RandomNumberGenerator.new()
    ran.seed = _seed

    for y in y_size:
        for x in x_size:
            if ran.randf() < ran_var:
                tile_map.set_cell(x+x_start,y+y_start, fill_val)
