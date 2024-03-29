
"""

function to check if mouse hovers a control, taking into account the camera zoom, offset and center mode

works even when dragging with mouse down over all controls, ineffecient but good

"""


## assign Camera2D
export (NodePath) var _camera2D : NodePath
var camera2D : Camera2D
func get_camera_2D() -> Camera2D:
    if not camera2D:
        camera2D = get_node(_camera2D)    
    return camera2D
    
    
static func _check_if_mouse_hovers_control(control : Control, camera2D : Camera2D, viewport : Viewport) -> bool:
    ## works even when dragging, must check all childs with this function
    ## took a while to work these offsets out so saved as a function
    ## example:
    ## _check_if_mouse_hovers_control(control,get_camera_2D(),get_viewport()):
    
    var mouse_position : Vector2 = viewport.get_mouse_position()
    var control_global_rect : Rect2 = control.get_global_rect()
    ## compensates if the child is scaled
    control_global_rect.size *= control.rect_scale ## if the drag child is scaled the rect needs scaling
    ## compensates for camera pos
    control_global_rect.position -= camera2D.position ## correct for camera pos
    if camera2D.anchor_mode == 1: ## if we have a center screen we must offset the pos
        mouse_position -= viewport.get_visible_rect().size/2.0
        
    return control_global_rect.has_point(mouse_position * camera2D.zoom)
