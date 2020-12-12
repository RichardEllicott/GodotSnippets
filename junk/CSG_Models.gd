"""


SAVED AS A CURRENT WORKING EXAMPLE (warning junk code)

to test csg mesh creation

github.com/RichardEllicott/GodotSnippets/




"""
tool
extends Spatial

export var tool_update = false setget set_tool_update
func set_tool_update(input):
    if input:
        _ready()
        tool_update = false



export(NodePath) var _mesh_instance
onready var mesh_instance = get_node(_mesh_instance)



var verts = PoolVector3Array()
var normals = PoolVector3Array()
var indices = PoolIntArray()
var uvs = PoolVector2Array()


export(Material) var default_material


func _ready():



    var arr_mesh = ArrayMesh.new()
    var mesh_arrays = []
    mesh_arrays.resize(ArrayMesh.ARRAY_MAX)


#    make_cube(0,0,0)

#    make_quad(
#        Vector3(0.0,0.0,0.0),
#        Vector3(0.0,0.0,1.0),
#        Vector3(0.0,1.0,1.0),
#        Vector3(0.0,1.0,0.0)
#    )


    make_sector_wall(
        Vector2(1,1),
        Vector2(2,3)
        )



    mesh_arrays[Mesh.ARRAY_VERTEX] = verts
    mesh_arrays[Mesh.ARRAY_NORMAL] = normals
    mesh_arrays[Mesh.ARRAY_INDEX] = indices

    mesh_arrays[Mesh.ARRAY_TEX_UV] = uvs

    arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_arrays)


    mesh_instance.mesh = arr_mesh

    mesh_instance.set_material_override (default_material)
#


func make_cube(x,y,z):
    #left
    make_quad(Vector3(x,y,z), Vector3(x,y+1,z), Vector3(x,y+1,z+1), Vector3(x,y,z+1))
    #right
    make_quad(Vector3(x+1,y,z+1), Vector3(x+1,y+1,z+1), Vector3(x+1,y+1,z), Vector3(x+1,y,z))
    #down
    make_quad(Vector3(x+1,y,z), Vector3(x,y,z), Vector3(x,y,z+1), Vector3(x+1,y,z+1))
    #up
    make_quad(Vector3(x+1,y+1,z+1), Vector3(x,y+1,z+1), Vector3(x,y+1,z), Vector3(x+1,y+1,z))
    #back
    make_quad(Vector3(x+1,y,z), Vector3(x+1,y+1,z), Vector3(x,y+1,z), Vector3(x,y,z))
    #front
    make_quad(Vector3(x,y,z+1), Vector3(x,y+1,z+1), Vector3(x+1,y+1,z+1), Vector3(x+1,y,z+1))

func make_quad(a,b,c,d):
    var length = len(verts)
    indices.append_array([
        length,
        length+1,
        length+2,
        length,
        length+2,
        length+3])
    verts.append_array([a,b,c,d])


#    # SMOOTH SHADING?
#    normals.append_array([
#        a.normalized(),
#        b.normalized(),
#        c.normalized(),
#        d.normalized()])

    var nvar = Vector3(0,1.0,0)
    normals.append_array([
        nvar,
        nvar,
        nvar,
        nvar])

    uvs.append_array([
        Vector2(0.0,0.0),
        Vector2(1.0,0.0),
        Vector2(1.0,1.0),
        Vector2(0.0,1.0)
     ])


func make_sector_wall(from, to, height = 1.0):

    var a = Vector3(from.x,0.0,from.y)
    var b = Vector3(to.x,0.0,to.y)

    var c = Vector3(to.x,height,to.y)
    var d = Vector3(from.x,height,from.y)

    make_quad(a,b,c,d)


    pass
