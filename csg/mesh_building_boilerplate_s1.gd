"""

More advanced boilerplate, drop in replacement for old boilerplate


UV projections all corrected for textures


Draw meshes on different surfaces in any order, eg, drawing multiple cubs of different materials:
    
    set_surface(0) # set surface(0)
    make_cube(Vector3())
    set_surface(1)
    make_cube(Vector3(1,0,1), Vector3(2,1,1))
    set_surface(2)
    make_cube(Vector3(2,0,2))
    set_surface(0)
    make_cube(Vector3(3,0,3), Vector3(2,1,1))
    set_surface(3)
    make_cube(Vector3(4,0,4), Vector3(2,1,1))

    
    _build_geometry() # will build all the geometry required, it will build each surface in turn


-supports multiple surfaces, Pool arrays dropped as they don't pass by reference, instead the Pool arrays are loaded at the last minute
    (this is a feature not a bug, it should not be a great deal slower)




-

ADDING simplex noise displacement modifier


"""
tool
extends MeshInstance

# click the varibale in the editor to rebuild the csg
export var tool_update = false setget set_tool_update
func set_tool_update(input):
    if input:
        _ready()
        tool_update = false
        _on_trigger_update()


# add the verts etc here
#var verts = PoolVector3Array()
#var normals = PoolVector3Array()
#var indices = PoolIntArray()
#var uvs = PoolVector2Array()

var verts = []
var normals = []
var indices = []
var uvs = []



export var smooth_shading = false


var _array_mesh
func _add_data_as_surface():
    """
    
    call this function to add all the verts,normals,indicies,uvs data to a new surface
    
    each time we call this it adds a new surface
    
    """
    


    if not _array_mesh:
        _array_mesh = ArrayMesh.new() # new array mesh object to build
        

    var mesh_arrays = [] # create input data for the ArrayMesh
    mesh_arrays.resize(ArrayMesh.ARRAY_MAX)
    
    if verts.size() == 0:
        push_warning("no verts found, adding dummy data!") # no trinagles use this surface material, this is a workaround for problems
        # having no actual data (empty is a problem for adding a surface)
        # in this case we want to still pretend to add a surface
        mesh_arrays[Mesh.ARRAY_VERTEX] = PoolVector3Array([Vector3()]) # add just one coordinate
    else:
        # add all the data from this node
        mesh_arrays[Mesh.ARRAY_VERTEX] = PoolVector3Array(verts)
        mesh_arrays[Mesh.ARRAY_NORMAL] = PoolVector3Array(normals)
        mesh_arrays[Mesh.ARRAY_INDEX] = PoolIntArray(indices)
        mesh_arrays[Mesh.ARRAY_TEX_UV] = PoolVector2Array(uvs)
        

    _array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_arrays)


    mesh = _array_mesh # finally set targets mesh


    
    

var surfaces_list = [] # lists of [verts,normals,indicies,uvs]


func get_surface_list(surface = 0):
    
    while surfaces_list.size() <= surface:
        
#        surfaces_list.append([
#            PoolVector3Array(), # verts
#            PoolVector3Array(), # normals
#            PoolIntArray(), # indices
#            PoolVector2Array(), # uvs
#           ])
        
        surfaces_list.append([
            [], # verts
            [], # normals
            [], # indices
            [], # uvs
           ])
        
        
        
    return surfaces_list[surface]
    
func set_surface(surface = 0):
    
    var surface_list = get_surface_list(surface)
    
    verts = surface_list[0]
    normals = surface_list[1]
    indices = surface_list[2]
    uvs = surface_list[3]
    
    

func flush_all_data():
    # flush all the previous mesh data now the object is created
    
#    verts = PoolVector3Array()
#    normals = PoolVector3Array()
#    indices = PoolIntArray()
#    uvs = PoolVector2Array()
    
#    verts = []
#    normals = []
#    indices = []
#    uvs = []
    
    surfaces_list = []
    
    _array_mesh = null # not clearing this can cause issues
    
    set_surface(0)

export var world_uv = true

export var uv_scale = 1.0

func make_quad(a: Vector3,  b: Vector3,  c: Vector3,  d: Vector3):
    """
    to reverse normal the quad, wrap it the other way
    a,b,c,d => d,c,b,a
    """

    var normal_vector = Plane(a,b,c).normal

    var length = len(verts)
    indices.append_array([
        length,
        length+1,
        length+2,
        length,
        length+2,
        length+3])

    verts.append_array([a,b,c,d])

    if smooth_shading:
        normals.append_array([
            a.normalized(),
            b.normalized(),
            c.normalized(),
            d.normalized()])
    else:

        normals.append_array([
            normal_vector,
            normal_vector,
            normal_vector,
            normal_vector])


    if world_uv: # UV based on world coordinates

        var a_s = a * uv_scale
        var b_s = b * uv_scale
        var c_s = c * uv_scale
        var d_s = d * uv_scale
        
        # analyse the normal vector to find the facing direction to find  the correct projection side
        var normal_abs_dir = normal_vector.abs().max_axis()
    
        match normal_abs_dir: # match the axis x y or z
            0:
                if normal_vector.x > 0:
                    uvs.append_array([ # correct for +x
                        Vector2(-a_s.z,-a_s.y),
                        Vector2(-b_s.z,-b_s.y),
                        Vector2(-c_s.z,-c_s.y),
                        Vector2(-d_s.z,-d_s.y)
                    ])
                else:
                    uvs.append_array([ # This is now correct for -x , flipped for x
                        Vector2(a_s.z,-a_s.y),
                        Vector2(b_s.z,-b_s.y),
                        Vector2(c_s.z,-c_s.y),
                        Vector2(d_s.z,-d_s.y)
                    ])
            1: # Y
                if normal_vector.y > 0:
                    uvs.append_array([
                        Vector2(a_s.x,a_s.z),
                        Vector2(b_s.x,b_s.z),
                        Vector2(c_s.x,c_s.z),
                        Vector2(d_s.x,d_s.z)
                    ])
                else:
                    uvs.append_array([
                        Vector2(-a_s.x,a_s.z),
                        Vector2(-b_s.x,b_s.z),
                        Vector2(-c_s.x,c_s.z),
                        Vector2(-d_s.x,d_s.z)
                    ])
            2: # Z
                if normal_vector.z > 0:
                    uvs.append_array([ # now correct for +z , flipped for -z
                        Vector2(a_s.x,-a_s.y),
                        Vector2(b_s.x,-b_s.y),
                        Vector2(c_s.x,-c_s.y),
                        Vector2(d_s.x,-d_s.y)
                    ])
                else:
                    uvs.append_array([
                        Vector2(-a_s.x,-a_s.y),
                        Vector2(-b_s.x,-b_s.y),
                        Vector2(-c_s.x,-c_s.y),
                        Vector2(-d_s.x,-d_s.y)
                    ])
                    

    else: # Default UV (no projection)

        uvs.append_array([
            Vector2(0.0, 0.0),
            Vector2(uv_scale, 0.0),
            Vector2(uv_scale, uv_scale),
            Vector2(0.0, uv_scale)
        ])



    

func make_cube(position, size = Vector3(1,1,1)):
    var x = position.x
    var y = position.y
    var z = position.z
    
    #left -x
    make_quad(

        Vector3(x,y+size.y,z),
        Vector3(x,y+size.y,z+size.z),
        Vector3(x,y,z+size.z),
        
        Vector3(x,y,z))
    #right +x
    make_quad(
        
        Vector3(x+size.x,y+size.y,z+size.z),
        Vector3(x+size.x,y+size.y,z),
        Vector3(x+size.x,y,z),
        Vector3(x+size.x,y,z+size.z))
    #down
    make_quad(
        Vector3(x+size.x,y,z),
        Vector3(x,y,z),
        Vector3(x,y,z+size.z),
        Vector3(x+size.x,y,z+size.z))
    #up
    make_quad(
        Vector3(x+size.x,y+size.y,z+size.z),
        Vector3(x,y+size.y,z+size.z),
        Vector3(x,y+size.y,z),
        Vector3(x+size.x,y+size.y,z))
    #back -z
    make_quad(
        
        Vector3(x+size.x,y+size.y,z),
        Vector3(x,y+size.y,z),
        Vector3(x,y,z),
        Vector3(x+size.x,y,z))
    #front +z
    make_quad(
        
        Vector3(x,y+size.y,z+size.z),
        Vector3(x+size.x,y+size.y,z+size.z),
        Vector3(x+size.x,y,z+size.z),
        Vector3(x,y,z+size.z))
    

 

export(Material) var material0
export(Material) var material1
export(Material) var material2
export(Material) var material3

export(Material) var material4
export(Material) var material5
export(Material) var material6
export(Material) var material7


func _copy_user_materials():
    if is_instance_valid(material0):
        if get_surface_material_count() > 0:
            set_surface_material(0,material0)
    if is_instance_valid(material1):
        if get_surface_material_count() > 1:
            set_surface_material(1,material1)
    if is_instance_valid(material2):
        if get_surface_material_count() > 2:
            set_surface_material(2,material2)
    if is_instance_valid(material3):
        if get_surface_material_count() > 3:
            set_surface_material(3,material3)
            
    if is_instance_valid(material4):
        if get_surface_material_count() > 4:
            set_surface_material(4,material4)
            
    if is_instance_valid(material5):
        if get_surface_material_count() > 5:
            set_surface_material(5,material5)
            
    if is_instance_valid(material6):
        if get_surface_material_count() > 6:
            set_surface_material(6,material6)
            
    if is_instance_valid(material7):
        if get_surface_material_count() > 7:
            set_surface_material(7,material7)
    
    

func _build_geometry():
    
    
    for n in surfaces_list.size():
        var suf_list = surfaces_list[n]
        set_surface(n)
#        set_surface(n)
#        _add_data_as_surface()
#        print(self, suf_list)
        
        if verts.size() > 0: # WARNING: 
            pass
        else:
#            push_warning ("one of the surfaces had no verts!")
            pass
            
        _add_data_as_surface()
    
    
    _copy_user_materials()
    
    flush_all_data()
    
    
        
    
    
func _ready():
    pass
    
    
func test_demo01():
    
    set_surface(0)
    make_cube(Vector3())
    set_surface(1)
    make_cube(Vector3(1,0,1), Vector3(2,1,1))
    set_surface(2)
    make_cube(Vector3(2,0,2))
    set_surface(0)
    make_cube(Vector3(3,0,3), Vector3(2,1,1))
    
    
#    set_surface(3)
#    make_cube(Vector3(4,0,4), Vector3(2,1,1))
    
    
    set_surface(4)
    make_cube(Vector3(5,0,5), Vector3(2,1,1))
    set_surface(5)
    make_cube(Vector3(6,0,6), Vector3(3,1,1))
    set_surface(0)
    make_cube(Vector3(7,0,7), Vector3(3,1,1))
    set_surface(1)
    make_cube(Vector3(8,0,8), Vector3(3,1,1))
    set_surface(2)
    make_cube(Vector3(9,0,9), Vector3(3,1,1))




func _on_trigger_update():

    

    test_demo01()
    
    
    apply_noise_modifier()
    
    
    _build_geometry()
    


    


    
    
    

var _noise

export var noise_strength = 1.0
export var noise_octaves = 4
export var noise_period = 20.0


func _get_noise_at_pos(position: Vector3):
    """
    input a 3D position
    
    return 3 noise values in a Vector3()
    
    used for procedural random offsets
    """
    
    var noise_seed = 4568
    
    if not _noise:
        _noise = OpenSimplexNoise.new()
        
    _noise.octaves = noise_octaves
    _noise.period = noise_period
    _noise.persistence = 0.8
        
    _noise.seed = noise_seed
    var a = _noise.get_noise_3dv(position)
    
    _noise.seed = noise_seed + 435
    var b = _noise.get_noise_3dv(position)
    
    _noise.seed = noise_seed + 2637
    var c = _noise.get_noise_3dv(position)
    
    
    return Vector3(a,b,c) * noise_strength
#    return Vector3(a,0,c)



func apply_noise_modifier():
    """
    
    simplifying working with geometry is the concept of a "modifier"
    
    this modifier runs through all the verts we have choosen to draw, then displaces their position with simplex noise
    
    construct geometry first
    run a modifier
    then finally build the array mesh
    
    """
    
    print("apply_simplex_displacement_modifier...")
    print("surface count:  ", surfaces_list.size())
    
    
    for surface in surfaces_list: # run through all surfaces
        
        var verts = surface[0] # get the verts
        
        for i in verts.size(): # run through each vert
            
            var vert = verts[i]
            verts[i] = _get_noise_at_pos(vert) + vert # equal to noise plus orginal position
    
    
    pass
