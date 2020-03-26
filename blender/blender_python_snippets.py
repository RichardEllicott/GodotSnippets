

import bpy


# all objects:
bpy.data.objects

# scene objects:
bpy.context.scene.objects

# selected object:
bpy.context.active_object

# deleting object:
bpy.data.objects.remove(ob, do_unlink=True)  # best option

# https://blender.stackexchange.com/questions/27234/python-how-to-completely-remove-an-object


# Set object mode:
bpy.ops.object.mode_set(mode='OBJECT')


# De-select all:
bpy.ops.object.select_all(action='DESELECT')


def remove_scene_objects(key=None):
    """
    remove all objects in scene, unless key is supplied, in which case remove all objects with key at start of name

    remove_scene_objects("GEN10_") # for example, removes "GEN10_Plane" etc
    """
    for ob in bpy.context.scene.objects:
        if key:
            if ob.name.startswith(key):
                bpy.data.objects.remove(ob, do_unlink=True)  # best option to delete, unlink first
        else:
            bpy.data.objects.remove(ob, do_unlink=True)  # best option to delete, unlink first



def select_all(): bpy.ops.object.select_all(action='SELECT')

def deselect_all(): bpy.ops.object.select_all(action='DESELECT')

def select_object(ob): #https://devtalk.blender.org/t/selecting-an-object-in-2-8/4177
    ob.select_set(state=True)
    bpy.context.view_layer.objects.active = ob



def edit_mode():
    bpy.ops.object.mode_set(mode='EDIT')

def object_mode():
    bpy.ops.object.mode_set(mode='OBJECT')

def apply_transform(location = True, scale = True, rotation = True):
    bpy.ops.object.transform_apply(location = location, scale = scale, rotation = rotation) # apply transform




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


"""
#LINKING OBJECT DATA NOTES HERE NOT YET SNIPPETED
# https://blender.stackexchange.com/questions/4878/how-to-copy-modifiers-with-attribute-values-from-active-object-to-selected-objec

import bpy

mod_obj = bpy.context.scene.objects["Cube"]           # cube with mods
modable_obj = bpy.context.scene.objects["Cube.001"]   # cube without mods

mod_obj.select = True
bpy.context.scene.objects.active = mod_obj
modable_obj.select = True

bpy.ops.object.make_links_data(type='MODIFIERS')

bpy.ops.object.select_all(action='DESELECT')
"""



