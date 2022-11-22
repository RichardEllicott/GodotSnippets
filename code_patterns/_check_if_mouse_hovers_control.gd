
"""

function to check if mouse hovers a control, taking into account the camera zoom, offset and center mode

works even when dragging with mouse down over all controls, ineffecient but good

"""


func _check_if_mouse_hovers_control(control : Control, camera2D : Camera2D) -> bool:
    ## works even when dragging, must check all childs with this function
    
    var viewport : Viewport = get_viewport()
    var mouse_position : Vector2 = viewport.get_mouse_position()
    
    var control_global_rect : Rect2 = control.get_global_rect()
    
    ## compensates if the child is scaled
    control_global_rect.size *= control.rect_scale ## if the drag child is scaled the rect needs scaling
    
    ## compensates for camera pos
    control_global_rect.position -= camera2D.position ## correct for camera pos
    
    if camera2D.anchor_mode == 1: ## if we have a center screen we must offset the pos
        mouse_position -= viewport.get_visible_rect().size/2.0
        
    return control_global_rect.has_point(mouse_position * camera2D.zoom)
