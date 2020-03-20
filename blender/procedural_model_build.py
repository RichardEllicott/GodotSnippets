"""

my easy blender script


note to add a custom module, the best place is to the addons folder direct


"""
import bpy
import bmesh


# import my_blender_lib_test


gen_key = "GEN10_" # all generated objects start with this key, this allows deleting old objects when refreshing  

default_material = bpy.data.materials['ProtoUV'] # needs to be a valid material

created_objects = [] # list, this does not delete properly (it's easier to track the key)


modifiers_template_name = "UVProjectLINK"
modifiers_template = None
for ob in bpy.context.scene.objects:
    if ob.name == modifiers_template_name:
         modifiers_template = ob
         break
assert(modifiers_template)




def remove_object(ob): bpy.data.objects.remove(ob, do_unlink=True) # remove an object from scene (note, reload to fully clear memory)

def remove_scene_objects(key=None):
    """
    remove all objects beginning with a key (which marks the generated objects)
    """
    for ob in bpy.context.scene.objects:
        if key:
            if ob.name.startswith(key):
                bpy.data.objects.remove(ob, do_unlink=True)  # best option to delete, unlink first
        else:
            bpy.data.objects.remove(ob, do_unlink=True)  # best option to delete, unlink first


def select_created_objects(key=gen_key):
    for ob in bpy.context.scene.objects:
        if ob.name.startswith(key):
            select_object(ob)


def select_all(): bpy.ops.object.select_all(action='SELECT')

def deselect_all(): bpy.ops.object.select_all(action='DESELECT')

def select_object(ob): #https://devtalk.blender.org/t/selecting-an-object-in-2-8/4177
    ob.select_set(state=True)
    bpy.context.view_layer.objects.active = ob



def edit_mode():
    bpy.ops.object.mode_set(mode='EDIT')

def object_mode():
    bpy.ops.object.mode_set(mode='OBJECT')



def primitive_plane_add(**kwargs):  # reflection
    bpy.ops.mesh.primitive_plane_add(**kwargs)  # edit to new standards
    ob = bpy.context.active_object
    ob.name = gen_key + ob.name  # set name
    ob.data.materials.append(default_material)  # add material
    created_objects.append(ob)
    return ob


def primitive_cube_add(**kwargs):
    bpy.ops.mesh.primitive_cube_add(**kwargs)  # edit to new standards
    ob = bpy.context.active_object
    ob.name = gen_key + ob.name  # set name
    ob.data.materials.append(default_material)  # add material
    created_objects.append(ob)
    return ob

remove_scene_objects(gen_key)  # remove all previously generated objects



def duplicate_object(ob, linked=0):
    """
    duplicate an object, return a ref to the new object
    uses the UI's duplicate function so works the same
    """
    object_mode()
    deselect_all()
    select_object(ob)
    bpy.ops.object.duplicate(linked=linked,mode='TRANSLATION')
    ob = bpy.context.active_object
    created_objects.append(ob)
    return ob



def set_object_dimensions(ob, dimensions = (1,1,1)):
    """
    works on an object similar to how the UI does it rescaling an object
    """
    deselect_all()
    select_object(ob)
    object_dimensions = bpy.context.object.dimensions
    for i in range(len(object_dimensions)):
        ob.scale[i] = dimensions[i]  / object_dimensions[i]


def apply_transform(location = True, scale = True, rotation = True):
    bpy.ops.object.transform_apply(location = location, scale = scale, rotation = rotation) # apply transform





def preset_01():
    ob = primitive_cube_add(size=2.0, location=(0, 0, 0))

    edit_mode()

    ob = primitive_cube_add(size=2.0, align='WORLD',location=(0, 0, 2))

    object_mode()
    ob = primitive_cube_add(size=2.0, location=(0, 0, 4))

def preset_02(): #creates a window
    ob1 = primitive_cube_add(size=1.0, location=(0.5, 0.5, 0.5))
    apply_transform()

    # bpy.ops.object.duplicate(linked=1,mode='TRANSLATION')
    # ob = bpy.context.active_object
    # ob.location = (0,0,2)

    ob2 = duplicate_object(ob1)
    ob2.location = (0,0,0)
    ob2.scale = (4,1,1)

    ob3 = duplicate_object(ob1)
    ob3.location = (0,0,1)
    ob3.scale = (1,1,2)

    ob3 = duplicate_object(ob1)
    ob3.location = (0,0,3)
    ob3.scale = (4,1,1)

    ob4 = duplicate_object(ob1)
    ob4.location = (3,0,1)
    ob4.scale = (1,1,2)

    remove_object(ob1)


    deselect_all()
    # select_all_created_objects()

    select_created_objects()

    bpy.ops.object.join()
    apply_transform()


    ob = bpy.context.active_object
    apply_transform(ob)

    set_object_dimensions(ob, (1,1.0/8.0,1))


    deselect_all()
    # select_object(ob)
    select_created_objects()
    select_object(modifiers_template)
    bpy.ops.object.make_links_data(type='MODIFIERS')
    deselect_all()




def delete_mesh_faces_by_ref(ref_list):
    """
    standard cube:

    0 left
    1 forward
    2 right
    3 back
    4 down
    5 up
    """

    edit_mode()
    obj = bpy.context.edit_object
    me = obj.data
    bm = bmesh.from_edit_mesh(me)

    face_cache = []

    n = 0

    for face in bm.faces:
        print("found face: ", face)
        

        if n in ref_list:
            face_cache.append(face)

        n+=1

    print("delete these faces:", face_cache)

    bmesh.ops.delete(bm, geom=face_cache, context="FACES") # https://docs.blender.org/api/current/bmesh.ops.html
    bmesh.update_edit_mesh(me, True) # update view

    object_mode()


def delete_faces_of_cube(back = False, front = False, bottom = False, top = False, left = False, right = False):
    delete_faces = []
    if left:
        delete_faces.append(0)
    if front:
        delete_faces.append(1)
    if right:
        delete_faces.append(2)
    if back:
        delete_faces.append(3)
    if bottom:
        delete_faces.append(4)
    if top:
        delete_faces.append(5)
    delete_mesh_faces_by_ref(delete_faces)



    pass



def preset_03(): # more advanced

    y1 = 1.0/4.0
    
    z1 = 0.25
    z2 = 0.5
    z3 = 0.25

    zt = z1 + z2 + z3

    x1 = 0.25
    x2 = 0.5
    x3 = 0.25


    ob_base = primitive_cube_add(size=1.0, location=(0.5, 0.5, 0.5))
    apply_transform()
    # ob_base.scale = (1,1,2)


    #Frame Part 1

    ob1 = duplicate_object(ob_base)
    ob1.location = (0,0,0)
    set_object_dimensions(ob1, (x1,y1,z1))

    ob2 = duplicate_object(ob_base)
    ob2.location = (0,0,z1)
    set_object_dimensions(ob2, (x1,y1,z2))

    ob3 = duplicate_object(ob_base)
    ob3.location = (0,0,z1+z2)
    set_object_dimensions(ob3, (x1,y1,z3))

    #Frame Part 2

    ob21 = duplicate_object(ob_base)
    ob21.location = (x1 + x2,0,0)
    set_object_dimensions(ob21, (x3,y1,z1))

    ob22 = duplicate_object(ob_base)
    ob22.location = (x1 + x2,0,z1)
    set_object_dimensions(ob22, (x3,y1,z2))

    ob23 = duplicate_object(ob_base)
    ob23.location = (x1 + x2,0,z1+z2)
    set_object_dimensions(ob23, (x3,y1,z3))


    #Top Ledge
    ob4 = duplicate_object(ob_base)
    ob4.location = (x1,0,z1+z2)
    set_object_dimensions(ob4, (x2,y1,z3))

    #Bottom Ledge
    ob24 = duplicate_object(ob_base)
    ob24.location = (x1,0,0)
    set_object_dimensions(ob24, (x2,y1,z1))



    # delete_mesh_faces_by_ref([4,5]) # up down of cube

    # delete_faces_of_cube(top = True, bottom = True)


    remove_object(ob_base)


    select_created_objects()
    bpy.ops.object.join()

    deselect_all()
    # select_object(ob)
    select_created_objects()
    select_object(modifiers_template)
    bpy.ops.object.make_links_data(type='MODIFIERS')
    deselect_all()


preset_03()






 
# END SEQUENCE
# object_mode()
# deselect_all()
# select_all_created_objects()


def print_scene_debug_info():
    print("********************************")
    for ob in bpy.context.scene.objects:
        print("found scene object, ", ob, ob.name)

    print("********************************")

    print(bpy.data.filepath)
    print("********************************")

    print(my_blender_lib_test.test())

    import sys
    print(sys.path)

print_scene_debug_info()


"""

old text follows

"""

# bpy.ops.mesh.primitive_plane_add(radius=1.2, view_align=False, enter_editmode=False, location=(0, 0, 0))
# bpy.ops.mesh.primitive_cube_add(view_align=False, enter_editmode=False, location=(0, 0, 0))
# bpy.ops.mesh.primitive_cone_add(view_align=False, enter_editmode=False, location=(0, 0, 0))
# bpy.ops.mesh.primitive_torus_add(rotation=(0, 0, 0), view_align=False, location=(0, 0, 0))


# objects = bpy.data.objects

# cube = objects['Cube']
# plane = objects['Plane']  # must be larger than the cube
# torus = objects['Torus']
# cone = objects['Cone']

# bool_one = cube.modifiers.new(type="BOOLEAN", name="bool 1")
# bool_one.object = plane
# bool_one.operation = 'DIFFERENCE'
# plane.hide = True

# bool_two = cube.modifiers.new(type="BOOLEAN", name="bool 2")
# bool_two.object = torus
# bool_two.operation = 'DIFFERENCE'
# torus.hide = True

# bool_three = cube.modifiers.new(type="BOOLEAN", name="bool 3")
# bool_three.object = cone
# bool_three.operation = 'DIFFERENCE'
# cone.hide = True∂
