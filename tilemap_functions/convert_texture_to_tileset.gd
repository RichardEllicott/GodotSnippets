"""

function to convert an image texture to TileSet


it will run from left to right across the image loading tiles


"""


func texture_to_tileset(input_texture, tile_width = 8, tile_height = 8, max_tiles = -1):
    """
	convert a Texture to a TileSet automatically

	runs from left to right loading tiles at the specified width and height. Up to the max tiles (-1 is unlimited)

    """
    var image_size = input_texture.get_size()

    var x_count = int(image_size.x / tile_width) # width of image in "tiles"
    var y_count = int(image_size.y / tile_height) # height of image in "tiles"

    var ts = TileSet.new()

    var tile_count = 0

    for i in x_count * y_count:

        if max_tiles >= 0 and i >= max_tiles: # ensure we have not loaded more than the max_tiles
            break

        var x_pos = i % x_count
        var y_pos = int(i / x_count)


        var id = ts.get_last_unused_tile_id()
        ts.create_tile(id)

        tile_count += 1

        ts.tile_set_texture(id, input_texture)

        var region = Rect2(
            Vector2(x_pos * tile_width, y_pos * tile_height),
            Vector2(tile_width,tile_height))

        ts.tile_set_region(id, region)

        ts.tile_set_name(id, "#%04d" % i) # add padding in the name to ensure alphabetical order matches integer order

    print("generated TileSet with %s tiles" % [tile_count])
    return ts
