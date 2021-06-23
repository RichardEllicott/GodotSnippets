"""

Basic CSG boilerplate showing drawing a quad

"""
tool
extends MeshInstance

# click the varibale in the editor to rebuild the csg
export var tool_update = false setget set_tool_update
func set_tool_update(input):
    if input:
        _ready()
        tool_update = false


# add the verts etc here
var verts = PoolVector3Array()
var normals = PoolVector3Array()
var indices = PoolIntArray()
var uvs = PoolVector2Array()

export var smooth_shading = false


func _update_mesh():
    # adds all the primitive we've created to the mesh
    # transfers the data to a target mesh

    var arr_mesh = ArrayMesh.new() # new array mesh object to build
    var mesh_arrays = []
    mesh_arrays.resize(ArrayMesh.ARRAY_MAX)

    # add all the data from this node
    mesh_arrays[Mesh.ARRAY_VERTEX] = verts
    mesh_arrays[Mesh.ARRAY_NORMAL] = normals
    mesh_arrays[Mesh.ARRAY_INDEX] = indices
    mesh_arrays[Mesh.ARRAY_TEX_UV] = uvs

    arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_arrays)

    mesh = arr_mesh # finally set targets mesh

    flush_all_data()

func flush_all_data():
    # flush all the previous mesh data now the object is created
    verts = PoolVector3Array()
    normals = PoolVector3Array()
    indices = PoolIntArray()
    uvs = PoolVector2Array()


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

        match normal_vector.abs().max_axis():
            0: # X
                uvs.append_array([
                    Vector2(a_s.y,a_s.z),
                    Vector2(b_s.y,b_s.z),
                    Vector2(c_s.y,c_s.z),
                    Vector2(d_s.y,d_s.z)
                ])
            1: # Y
                uvs.append_array([
                    Vector2(a_s.x,a_s.z),
                    Vector2(b_s.x,b_s.z),
                    Vector2(c_s.x,c_s.z),
                    Vector2(d_s.x,d_s.z)
                ])
            2: # Z
                uvs.append_array([
                    Vector2(a_s.x,a_s.y),
                    Vector2(b_s.x,b_s.y),
                    Vector2(c_s.x,c_s.y),
                    Vector2(d_s.x,d_s.y)
                ])

    else: # Default UV (no projection)

        uvs.append_array([
            Vector2(0.0, 0.0),
            Vector2(uv_scale, 0.0),
            Vector2(uv_scale, uv_scale),
            Vector2(0.0, uv_scale)
        ])



func _ready():

    var quad_pos = Vector3(0.5,0,0)

    make_quad(
        Vector3(-1,0,-1) + quad_pos,
        Vector3(1,0,-1) + quad_pos,
        Vector3(1,0,1) + quad_pos,
        Vector3(-1,0,1) + quad_pos
        )

    _update_mesh()


    pass # Replace with function body.
