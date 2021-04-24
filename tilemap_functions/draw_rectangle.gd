"""

programmatic draw to TileSet


"""



func draw_rectangle(_rect, val = 0):

    for x in _rect.size.x:

        #top line
        set_cell(
            x+_rect.position.x,
            _rect.position.y,
            val)
        #bottom line
        set_cell(
            x+_rect.position.x,
            _rect.position.y + _rect.size.y - 1,
            val)

    for y in _rect.size.y:
        #left line
        set_cell(
            _rect.position.x,
            _rect.position.y+y,
            val)
        # right line
        set_cell(
            _rect.position.x+ _rect.size.x -1,
            _rect.position.y+y,
            val)