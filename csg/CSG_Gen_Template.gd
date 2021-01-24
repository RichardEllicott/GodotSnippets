"""

CSG Mesh Generation Template

example:

    make_cube(0,0,0)

    make_quad(
        Vector3(-1,1,0),
        Vector3(1,1,0),
        Vector3(1,-1,1),
        Vector3(-1,-1,1)
       )

    _update_mesh # call after builing meshes



Can generate shapes with automatic normals:

    Quads
    Triangle
    Cube

TODO:
    n-gons





"""
tool
extends Node

export var tool_update = false setget set_tool_update
func set_tool_update(input):
    if input:
        _ready()
        tool_update = false


#
export(NodePath) var _mesh_instance
onready var mesh_instance = get_node(_mesh_instance)
#
#var mesh_instance = self


var verts = PoolVector3Array()
var normals = PoolVector3Array()
var indices = PoolIntArray()
var uvs = PoolVector2Array()


export(Material) var default_material


export var smooth_shading = false

func _ready():

    make_cube(0,0,0)

    make_sector_wall(Vector2(),Vector2(3,3))

    make_sector_wall(Vector2(3,3),Vector2(6,3))

    # WORKING QUAD TEST!!
#    make_quad(
#        Vector3(-1,1,0),
#        Vector3(1,1,0),
#        Vector3(1,-1,1),
#        Vector3(-1,-1,1)
#       )


#    make_triangle(Vector3(),Vector3(0,1,0), Vector3(1,1,0))

    _update_mesh()



func _update_mesh():

    var arr_mesh = ArrayMesh.new()
    var mesh_arrays = []
    mesh_arrays.resize(ArrayMesh.ARRAY_MAX)


    mesh_arrays[Mesh.ARRAY_VERTEX] = verts
    mesh_arrays[Mesh.ARRAY_NORMAL] = normals
    mesh_arrays[Mesh.ARRAY_INDEX] = indices

    mesh_arrays[Mesh.ARRAY_TEX_UV] = uvs

    arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_arrays)


    mesh_instance.mesh = arr_mesh

#    mesh_instance.set_material_override (default_material)


    verts = PoolVector3Array()
    normals = PoolVector3Array()
    indices = PoolIntArray()
    uvs = PoolVector2Array()



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



export var world_uv = true

var uv_scale = 1.0

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

    if smooth_shading:
        normals.append_array([
            a.normalized(),
            b.normalized(),
            c.normalized(),
            d.normalized()])
    else:

        var normal_vector = Plane(a,b,c).normal

        normals.append_array([
            normal_vector,
            normal_vector,
            normal_vector,
            normal_vector])





    if world_uv: # UV based on world coordinates

        var normal_vector = Plane(a,b,c).normal

        var direction = -1
        var largest_val = -1

        normal_vector.x = abs(normal_vector.x)
        normal_vector.y = abs(normal_vector.y)
        normal_vector.z = abs(normal_vector.z)

        if normal_vector.x > largest_val:
            direction = 0
            largest_val = normal_vector.x
        if normal_vector.y > largest_val:
            direction = 1
            largest_val = normal_vector.y
        if normal_vector.z > largest_val:
            direction = 2
            largest_val = normal_vector.z

#        direction = 2

        match direction:

            0:
                # Project X
                uvs.append_array([
                    Vector2(a.y*uv_scale,a.z*uv_scale),
                    Vector2(b.y*uv_scale,b.z*uv_scale),
                    Vector2(c.y*uv_scale,c.z*uv_scale),
                    Vector2(d.y*uv_scale,d.z*uv_scale)
                ])

            1:
                # Project Y
                uvs.append_array([
                    Vector2(a.x*uv_scale,a.z*uv_scale),
                    Vector2(b.x*uv_scale,b.z*uv_scale),
                    Vector2(c.x*uv_scale,c.z*uv_scale),
                    Vector2(d.x*uv_scale,d.z*uv_scale)
                ])

            2:
                # Project Z
                uvs.append_array([
                    Vector2(a.x*uv_scale,a.y*uv_scale),
                    Vector2(b.x*uv_scale,b.y*uv_scale),
                    Vector2(c.x*uv_scale,c.y*uv_scale),
                    Vector2(d.x*uv_scale,d.y*uv_scale)
                ])













    else: # Default UV

        uvs.append_array([
            Vector2(0.0, 0.0),
            Vector2(uv_scale, 0.0),
            Vector2(uv_scale, uv_scale),
            Vector2(0.0, uv_scale)
        ])



func make_triangle(a,b,c):

    #https://godotforums.org/discussion/20592/draw-a-triangle-with-gdnative

    var length = len(verts)
    indices.append_array([
        length,
        length+1,
        length+2
        ])
    verts.append_array([a,b,c])

    if smooth_shading:
        normals.append_array([
            a.normalized(),
            b.normalized(),
            c.normalized()
            ])
    else:
        var nvar = Plane(a,b,c).normal
        normals.append_array([
            nvar,
            nvar,
            nvar
            ])


    # NOT CORRECT?!?
    uvs.append_array([
        Vector2(0.0,0.0),
        Vector2(1.0,0.0),
        Vector2(1.0,1.0)
     ])


    pass


func make_floor(coors):
    pass

func make_sector_wall(from, to, floor_elevation = 0.0, wall_height = 1.0):

    var a = Vector3(from.x,floor_elevation,from.y)
    var b = Vector3(to.x,floor_elevation,to.y)

    var c = Vector3(to.x,floor_elevation+wall_height,to.y)
    var d = Vector3(from.x,floor_elevation+wall_height,from.y)

    make_quad(a,b,c,d)





