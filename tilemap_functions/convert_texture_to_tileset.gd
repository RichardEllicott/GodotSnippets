"""

function to convert an image texture to TileSet


it will run from left to right across the image loading tiles


"""



func texture_to_tileset(input_texture, tile_size = Vector2(8,8), max_tiles = -1):
    """
    take an input Texture, convert it to a TileSet automaticly
    
    __  is now for self contained functions that would normally be in a library
    
    """
    var image_size = input_texture.get_size()

    var x_count = int(image_size.x / tile_size.x)
    var y_count = int(image_size.y / tile_size.y)

    var ts = TileSet.new()

    var tile_count = 0

    for i in x_count*y_count:

        if max_tiles >= 0 and i >= max_tiles:
            break

        var x_pos = i % x_count
        var y_pos = int(i / x_count)

        var id = ts.get_last_unused_tile_id()
        ts.create_tile(id)

        ts.tile_set_texture(id, input_texture)

        var tile_region = Rect2(
            Vector2(x_pos * tile_size.x, y_pos * tile_size.y),
            tile_size)

        ts.tile_set_region(id, tile_region)

        ts.tile_set_name(id, "#%04d" % i) # sets the names with padding to ensure godot lists them in order

        tile_count += 1


    print("generated tileset with %s tiles" % [tile_count])
    return ts
