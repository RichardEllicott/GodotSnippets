

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


def deselect_all():
    bpy.ops.object.select_all(action='DESELECT')

def select_object(ob): #https://devtalk.blender.org/t/selecting-an-object-in-2-8/4177
    ob.select_set(state=True)
    bpy.context.view_layer.objects.active = ob



#LINKING OBJECT DATA
# https://blender.stackexchange.com/questions/4878/how-to-copy-modifiers-with-attribute-values-from-active-object-to-selected-objec

import bpy

mod_obj = bpy.context.scene.objects["Cube"]           # cube with mods
modable_obj = bpy.context.scene.objects["Cube.001"]   # cube without mods

mod_obj.select = True
bpy.context.scene.objects.active = mod_obj
modable_obj.select = True

bpy.ops.object.make_links_data(type='MODIFIERS')

bpy.ops.object.select_all(action='DESELECT')




