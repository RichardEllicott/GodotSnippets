"""

programmatic draw to TileSet


usage:

draw_rectangle(Rect2(3,3,11,11),1)

draw_filled_rectangle(Rect2(3,3,11,11),1)


"""

func draw_rectangle(_rect, val = 0):
    """
    hollow rectangle, used to draw a quick border
    """
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


func draw_filled_rectangle(_rect, val = 0):
    """
    filled rectangle
    """
    for x in _rect.size.x:
        for y in _rect.size.y:
            set_cell(
                _rect.position.x + x,
                _rect.position.y + y,
                val
            )
