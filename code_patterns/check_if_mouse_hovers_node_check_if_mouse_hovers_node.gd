



func _check_if_mouse_hovers_node(control : Control, camera2D : Camera2D) -> bool:
    
    
    var viewport : Viewport = get_viewport()
    var mouse_position : Vector2 = viewport.get_mouse_position()

    
    var viewport_rect = viewport.get_visible_rect()
    
    
    var check_hover_rect : Rect2 = control.get_global_rect()
    
    ## compensates if the child is scaled
    check_hover_rect.size *= control.rect_scale ## if the drag child is scaled the rect needs scaling
    
    ## compensates for camera pos
    check_hover_rect.position -= camera2D.position ## correct for camera pos
    
    var check_pos = mouse_position
    
    
    if camera2D.anchor_mode == 1: ## if we have a center screen we must offset the pos
        check_pos -= viewport_rect.size/2.0
        
    return check_hover_rect.has_point(check_pos * camera2D.zoom)
