"""

GridDoubleScaleHotkeys v 1.0 (finished 26/03/2020)

Blender addon that adds shortcuts to blender to double and half the grid scale similar to Doom level editors

shortcuts are assigned to NUMPAD_PLUS and NUMPAD_MINUS keys, usually they are redundant for zooming next to the mouse wheel


based on templates:

https://docs.blender.org/manual/en/latest/advanced/scripting/addon_tutorial.html

coded by Richard Ellicott (https://github.com/RichardEllicott/)


MyNotes:
add preferences for user?
https://github.com/pitiwazou/Scripts-Blender/blob/Older-Scripts/addon_keymap_template
https://blender.stackexchange.com/questions/1497/how-can-i-call-a-specific-keymap-to-draw-within-my-addonpreferences

addon preferences for 2.8:
https://docs.blender.org/api/current/bpy.types.AddonPreferences.html?highlight=addonpreferences


"""
# Preferences:

double_key_shortcut = "NUMPAD_PLUS" # you can change the hot keys here
half_key_shortcut = "NUMPAD_MINUS"

# Begin Plugin

bl_info = {
    "name": "Grid Scale Double/Half Shotcuts",
    "blender": (2, 80, 0),
    "category": "Object",
}

import bpy

# Functions:

def set_grid_scale(scale = 1):
    """
    sets the grid scale in the UI
    https://blender.stackexchange.com/questions/154610/how-do-you-programatically-set-grid-scale

    warning may be obsolete
    """
    AREA = 'VIEW_3D'
    for window in bpy.context.window_manager.windows:
        for area in window.screen.areas:
            if not area.type == AREA:
                continue
            for s in area.spaces:
                if s.type == AREA:
                    s.overlay.grid_scale = scale
                    break

def get_grid_scale():
    """
    returns grid scale as a float
    """
    AREA = 'VIEW_3D'
    for window in bpy.context.window_manager.windows:
        for area in window.screen.areas:
            if not area.type == AREA:
                continue
            for s in area.spaces:
                if s.type == AREA:
                    return s.overlay.grid_scale


def half_grid_scale():
    set_grid_scale(get_grid_scale()/2.0)

def double_grid_scale():
    set_grid_scale(get_grid_scale()*2.0)


# Blender Operator Objects:

class ObjectDoubleGridScale(bpy.types.Operator):
    """Object Double Grid Scale"""
    bl_idname = "object.double_grid_scale"
    bl_label = "Double Grid Scale"
    bl_options = {'REGISTER', 'UNDO'}

    # total: bpy.props.IntProperty(name="Steps", default=2, min=1, max=100) # was for the shortcut context

    def execute(self, context):

        double_grid_scale()
        # half_grid_scale()

        # scene = context.scene
        # cursor = scene.cursor.location
        # obj = context.active_object

        # for i in range(self.total):
        #     obj_new = obj.copy()
        #     scene.collection.objects.link(obj_new)

        #     factor = i / self.total
        #     obj_new.location = (obj.location * factor) + (cursor * (1.0 - factor))

        return {'FINISHED'}


class ObjectHalfGridScale(bpy.types.Operator):
    """Object Half Grid Scale"""
    bl_idname = "object.half_grid_scale"
    bl_label = "Half Grid Scale"
    bl_options = {'REGISTER', 'UNDO'}

    def execute(self, context):

        half_grid_scale()

        return {'FINISHED'}


def menu_func(self, context): # used atm
    self.layout.operator(ObjectDoubleGridScale.bl_idname)

# store keymaps here to access after registration
addon_keymaps = []


def register():
    bpy.utils.register_class(ObjectDoubleGridScale)
    bpy.utils.register_class(ObjectHalfGridScale) # DUPLICATED PATTERN

    # bpy.types.VIEW3D_MT_object.append(menu_func) # don't add to object menu!

    # handle the keymap
    wm = bpy.context.window_manager
    # Note that in background mode (no GUI available), keyconfigs are not available either,
    # so we have to check this to avoid nasty errors in background case.
    kc = wm.keyconfigs.addon
    if kc:
        km = wm.keyconfigs.addon.keymaps.new(name='Object Mode', space_type='EMPTY')
        # kmi = km.keymap_items.new(ObjectDoubleGridScale.bl_idname, 'T', 'PRESS', ctrl=True, shift=True) # OLD PAT WITH CTRL SHIFT
        kmi = km.keymap_items.new(ObjectDoubleGridScale.bl_idname, double_key_shortcut, 'PRESS')

        kmi = km.keymap_items.new(ObjectHalfGridScale.bl_idname, half_key_shortcut, 'PRESS') # DUPLICATED PATTERN

        # kmi.properties.total = 4 # not needed
        addon_keymaps.append((km, kmi))

def unregister():
    # Note: when unregistering, it's usually good practice to do it in reverse order you registered.
    # Can avoid strange issues like keymap still referring to operators already unregistered...
    # handle the keymap
    for km, kmi in addon_keymaps:
        km.keymap_items.remove(kmi)
    addon_keymaps.clear()

    bpy.utils.unregister_class(ObjectDoubleGridScale)
    bpy.utils.unregister_class(ObjectHalfGridScale) # DUPLICATED PATTERN
    bpy.types.VIEW3D_MT_object.remove(menu_func)


if __name__ == "__main__":
    register()



