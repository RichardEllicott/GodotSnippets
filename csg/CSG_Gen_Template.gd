"""

My ProtoType CSG Object v 0.02

(very rough design atm)


contains many csg drawing functions

the csg functions interact with this boilerplate object
unfortunatly drawing csg is complicated so seperating these functions is complicated


the object will update the target defined as mesh_instance

first call a drawing function or more like make_quad
then call _update_mesh when finished to build the final mesh




"""
tool
extends Node

export var tool_update = false setget set_tool_update
func set_tool_update(input):
    if input:
        _ready()
        tool_update = false


export(NodePath) var _mesh_instance
onready var mesh_instance = get_node(_mesh_instance)


export(NodePath) var _poly_instance
onready var poly_instance = get_node(_poly_instance)


# A LIST OF LEVEL Polygon2D s
export(NodePath) var _level_node2d
onready var level_node2d = get_node(_level_node2d)

#
#var mesh_instance = self


var verts = PoolVector3Array()
var normals = PoolVector3Array()
var indices = PoolIntArray()
var uvs = PoolVector2Array()


export(Material) var default_material


export var smooth_shading = false


export var world_uv = false

var uv_scale = 1.0



func debug_test_normal_direction_control():

    var length = 8.0
    var circle_div = 8
    var deg_inc = 360.0/circle_div
    for i in circle_div:
        var rot = deg_inc * i

        var x = sin(deg2rad(rot)) * length
        var y = cos(deg2rad(rot)) * length

        var a = Vector2(0,0)
        var b = Vector2(x,y)

        make_sector_wall(a,b,0,1) # LEFT SIDE FACING
        make_sector_wall(b,a,0,1) # RIGHT FACING


#        make_triangle(Vector3(), Vector3(0,length,0), Vector3(length*b.x,0,length*b.y))

        pass



    pass


func make_plane(position = Vector3(), radius = 1.0):

    make_quad(
        Vector3(-radius,0,-radius) + position,
        Vector3(radius,0,-radius) + position,
        Vector3(radius,0,radius) + position,
        Vector3(-radius,0,radius) + position
       )

export var line_width = 1.0/16.0
export var base_radius = 1.0/2.0

func _ready():

#    make_cube(0,0,0)
#
#    make_sector_wall(Vector2(),Vector2(3,3))
#
#    make_sector_wall(Vector2(3,3),Vector2(6,3))

    # WORKING QUAD TEST!!

#    make_plane(Vector3(),2)


    make_circle_grid()

    _update_mesh()



func make_circle_grid():

    make_circle_mesh(base_radius*1.0,line_width)
    make_circle_mesh(base_radius*2.0,line_width)
    make_circle_mesh(base_radius*3.0,line_width)
    make_circle_mesh(base_radius*4.0,line_width)
    make_circle_mesh(base_radius*5.0,line_width)
    make_circle_mesh(base_radius*6.0,line_width)
    make_circle_mesh(base_radius*7.0,line_width)
    make_circle_mesh(base_radius*8.0,line_width)

    var deg = 30.0
    var inc = int(360.0/deg)
    for i in inc:

        make_2d_line_mesh(deg2rad(deg*i), 8.0*base_radius, line_width)

        #subline
#        make_2d_line_mesh(deg2rad(deg*i+deg/2.0), 8.0*base_radius, line_width/4.0)




func make_circle_mesh(radius = 2.0, line_width = 0.5/4.0):
    """
    draws a flat circle of quads
    """

    var radius1 = radius - line_width
    var radius2 = radius + line_width

    var angle = 45.0/2.0/4.0
    var segments = int(360.0/angle)

    print("segments: %s" % segments)

    for i in segments:

        var theta = deg2rad(angle * i)

        var cicle_pos = Vector3(cos(theta),0,sin(theta))

        var a = cicle_pos * radius1
        var b = cicle_pos * radius2

        var theta2 = deg2rad(angle * (i+1))
        var cicle_pos2 = Vector3(cos(theta2),0,sin(theta2))

        var c = cicle_pos2 * radius2
        var d = cicle_pos2 * radius1

        make_quad(a,b,c,d)

#        break


        pass



    pass




func make_2d_line_mesh(theta = 0.0, magnitude = 1.0, width = 0.25):


    var axis = Vector3(0,1,0)

    var offset = Vector3()

    var x_scale = width
    var y_scale = magnitude

    var a = Vector3(-1*x_scale,0,0*y_scale)
    var b = Vector3(1*x_scale,0,0*y_scale)
    var c = Vector3(1*x_scale,0,1*y_scale)
    var d = Vector3(-1*x_scale,0,1*y_scale)

    make_quad(
        (a+offset).rotated(axis,theta),
        (b+offset).rotated(axis,theta),
        (c+offset).rotated(axis,theta),
        (d+offset).rotated(axis,theta)
       )



    pass

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

    mesh_instance.mesh = arr_mesh # finally set targets mesh

#    mesh_instance.set_material_override (default_material)

    flush_all_data()

func flush_all_data():
    # flush all the previous mesh data now the object is created
    verts = PoolVector3Array()
    normals = PoolVector3Array()
    indices = PoolIntArray()
    uvs = PoolVector2Array()



func make_ngon(a, b = null, c = null, d = null):
    """
    not perfect yet

    this pattern is an attempt to generalise other functions

    """
    if a is Array:
        var a_size = a.size()
        match a_size:
            3:
                make_triangle(
                    a[0],
                    a[1],
                    a[2]
                   )
                return
            4:
                make_quad(
                        a[0],
                        a[1],
                        a[2],
                        a[3]
                        )
                return

    if d != null:
        make_quad(a,b,c,d)
        return

    elif c != null:
        make_triangle(a,b,c)
        return




func make_quad(a: Vector3,  b: Vector3,  c: Vector3,  d: Vector3):
    """
    to reverse normal the quad, wrap it the other way

    a,b,c,d => d,c,b,a

    example plane facing upwards (like blender):

    make_quad(
        Vector3(-radius,0,-radius),
        Vector3(radius,0,-radius),
        Vector3(radius,0,radius),
        Vector3(-radius,0,radius)
    )

    """

    var normal_vector = Plane(a,b,c).normal

    # NOTE FAILED TO REVERSE NORMAL BY JUST FLIPPING IT (CULLING)

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


func make_triangle(a,b,c):


    if a is Vector2:
        a = Vector3(a.x,0,a.y)
    if b is Vector2:
        b = Vector3(b.x,0,b.y)
    if c is Vector2:
        c = Vector3(c.x,0,c.y)

    var normal_vector = Plane(a,b,c).normal

    var length = len(verts)
    indices.append_array([
        length,
        length+1,
        length+2,
        ])

    verts.append_array([a,b,c])

    if smooth_shading:
        normals.append_array([
            a.normalized(),
            b.normalized(),
            c.normalized()
            ])
    else:

        normals.append_array([
            normal_vector,
            normal_vector,
            normal_vector
            ])


    if world_uv: # UV based on world coordinates

        var a_s = a * uv_scale
        var b_s = b * uv_scale
        var c_s = c * uv_scale

        match normal_vector.abs().max_axis():
            0: # X
                uvs.append_array([
                    Vector2(a.y*uv_scale,a.z*uv_scale),
                    Vector2(b.y*uv_scale,b.z*uv_scale),
                    Vector2(c.y*uv_scale,c.z*uv_scale),
                ])
            1: # Y
                uvs.append_array([
                    Vector2(a.x*uv_scale,a.z*uv_scale),
                    Vector2(b.x*uv_scale,b.z*uv_scale),
                    Vector2(c.x*uv_scale,c.z*uv_scale),
                ])
            2: # Z
                uvs.append_array([
                    Vector2(a.x*uv_scale,a.y*uv_scale),
                    Vector2(b.x*uv_scale,b.y*uv_scale),
                    Vector2(c.x*uv_scale,c.y*uv_scale),
                ])

    else: # Default UV (no projection)

        uvs.append_array([
            Vector2(0.0, 0.0),
            Vector2(uv_scale, 0.0),
            Vector2(uv_scale, uv_scale),
        ])


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



func Vector2_Array_To_Vector3(array):
    var ret = []
    for v in array:
        ret.append(Vector3(v.x,0,v.y))
    return ret

func Vector3_Array_To_Vector2(array):
    var ret = []
    for v in array:
        ret.append(Vector2(v.x,v.z))
    return ret


func make_walls(coors, floorheight = 0.0, ceilingheight = 1.0):

    # make a floor with walls around it

    var coors_size = coors.size()
    for i in coors_size:
        var from = coors[i]
        var to = coors[(i + 1) % coors_size]
        make_sector_wall(from,to,floorheight,ceilingheight)


func make_floor(coors, floorheight = 0):
    """
    TESTED WORKING!


    build a floor from a set of polygon coordinates

    to do this we must convert the polygon into triangles

    we use the built in delunacy:
        Geometry.triangulate_polygon(coors)

    https://docs.godotengine.org/en/stable/classes/class_geometry.html

    """

    var delun = Geometry.triangulate_polygon(coors)

    var offset = Vector3(0,floorheight,0)

    for i in delun.size() / 3: # we iterate the coordinates in groups of 3

        i *= 3

        var a = coors[delun[i]] # triangle coordinate a
        var b = coors[delun[i+1]] # b
        var c = coors[delun[i+2]] # c

        a = Vector3(a.x,0,a.y) + offset
        b = Vector3(b.x,0,b.y) + offset
        c = Vector3(c.x,0,c.y) + offset

        print("%s %s %s" % [a,b,c])

        make_triangle(a,b,c)

func make_sector_wall(from : Vector2, to : Vector2, floor_elevation : float = 0.0, wall_height : float = 1.0):
    """
    TESTED WORKING!

    sector wall for doom, has
    """

    var a = Vector3(from.x,floor_elevation,from.y)
    var b = Vector3(to.x,floor_elevation,to.y)

    var c = Vector3(to.x,floor_elevation+wall_height,to.y)
    var d = Vector3(from.x,floor_elevation+wall_height,from.y)

    make_quad(a,b,c,d)


func LinedefHashString(a,b):

    var case = 0
    if a.x == b.x:

        if a.y > b.y:
            case = 1

    elif a.y > b.y:
        case = 1

    match case:
        0:
            return "%s%s" % [a,b]
        1:
            return "%s%s" % [b,a]


func Polygon2DResetTransform(poly2d):
    """
    apply the position as a transform


    note does not affect rotation
    """

    var new_poly = []

    if poly2d.polygon:
        for v in poly2d.polygon:

            new_poly.append(v + poly2d.global_position)



    poly2d.polygon = new_poly

    poly2d.global_position = Vector2()


func analyse_level_polys():

    var floor_scale = 1.0/16.0

    var RanGen = RandomNumberGenerator.new()
    RanGen.seed = 0

    var linedefs = {}

    var linedef_joins = {} # ignore these walls




    var childs = []
    for child in level_node2d.get_children():

        if child is Polygon2D:

            Polygon2DResetTransform(child)


            childs.append(child)
            var ran_col = Color.from_hsv(RanGen.randf() * 6,1,1,0.5)
            child.modulate = ran_col

            if not child.has_meta("heightfloor"):
                child.set_meta("heightfloor",0.0)
            var heightfloor = child.get_meta("heightfloor")


#            print("found poly: %s" % child)

            if child.polygon:

                var draw_poly = []

                for v in child.polygon:
                    draw_poly.append((child.global_position + v) * floor_scale)

                make_floor(draw_poly,heightfloor)


                for i in draw_poly.size():

                    var a = draw_poly[i]
                    var b = draw_poly[(i + 1)%draw_poly.size()]


                    var hash_string = LinedefHashString(a,b)


                    if hash_string in linedefs:
#                        print("FOUND JOIN! %s" % hash_string)

                        var prevchild = linedefs[hash_string][2]
#                        print("XXX ADDD ", prevchild)
                        linedef_joins[hash_string] = [a,b,child,prevchild]

#                        print("sss ",child,prevchild)

                        var h1 = child.get_meta("heightfloor")
                        var h2 = prevchild.get_meta("heightfloor")

                        if h1 > h2:
                            var x = h1
                            h1 = h2
                            h2 = x

#                        print("%s %s" %  [h1,h2])

                        make_sector_wall(a,b,h1,h2-h1)

                    linedefs[hash_string] = [a,b,child]
                    pass

                pass



    for k in linedefs:

        var v = linedefs[k]

        var a = v[0]
        var b = v[1]
        var child = v[2]
        var heightfloor = child.get_meta("heightfloor")
        var heightceiling = child.get_meta("heightceiling")


        print("AB here:",a,b)

        if not k in linedef_joins:
            make_sector_wall(a,b,heightfloor,heightceiling)
        else:
            print("IGNORED A WALL!!!")

        pass
