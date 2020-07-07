"""

should be added as a singleton to autoloads as "mylib"

contains helper functions

method for loading this file like a dynamic object:
const MyLib = preload("eemylib.gd")
onready var mylib = MyLib.new()
would create this everyplace it is written


functions so far:
    find(name) #find anything


"""
extends Node


func _ready():
    print("loading ee3_lib...")


func color_lerp(color1, color2, value = 0.5):
    return color1.linear_interpolate(color2, value) # a color of an RGBA(128, 128, 0, 255)

func color_multiply(color1, color2):
    """
    like colorize
    https://en.wikipedia.org/wiki/Blend_modes#Multiply
    """
    return Color(
        color1[0] * color2[0],
        color1[1] * color2[1],
        color1[2] * color2[2],
        color1[3] * color2[3])

func color_screen(color1, color2):
    """
    https://en.wikipedia.org/wiki/Blend_modes#Screen
    """
    return color_multiply(
        color1.inverted(),
        color2.inverted()
        ).inverted()


# https://godotengine.org/qa/17524/how-to-find-an-instanced-scene-by-its-name
func _find_node_by_name(root, name):
    """
    finds a node by name in all childs of root
    intended to be used for global find function:
        mylib.find(name)
    """
    if(root.get_name() == name):
        return root
    for child in root.get_children():
        if(child.get_name() == name):
            return child
        var found = _find_node_by_name(child, name)
        if(found):
            return found
    return null

func find(name):
    """
    global find by name (searches whole scene)
    """
    var node = _find_node_by_name(get_tree().get_root(), name)
    if not node:
        print('WARNING: no object found named ""%s"' % name)
    return node



func find_childs_by_tags(root,tags, max_results=null):
    """
    checks for tags list ["tag1","tag2"] on all children
    returns all children that have all tags
    children must have a dictionary with tags like:
        {"tag1":true,"tag2":true}
    """

    if typeof(tags) == TYPE_STRING:
        tags = [tags]

    var ret = []
    var ret_len = 0
    for child in root.get_children():
        if max_results:
            if ret_len >= max_results: # if we have found max childs
                break

        var tag_found = true
        if "tags" in child:
            for tag in tags:
                if not tag in child.tags:
                    tag_found = false
                    break
        else:
            tag_found = false

        if tag_found:
            ret.append(child)
            ret_len += 1

    return ret



func random_Vector3(radius = 1):
    """
    random position in cube
    """
    var ret = Vector3(
        randf()*(radius*2)-radius,
        randf()*(radius*2)-radius,
        randf()*(radius*2)-radius)
    return ret


func file_exists(path):
    """
    check a file exists
    """
    var file2Check = File.new()
    return file2Check.file_exists(path)


func dir(path):
    """
    return a list of files in directory (no subdirs)
    example:
    mylib.dir("res://entities")
    """
    var ret = []
    var dir = Directory.new()
    if dir.open(path) == OK:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while (file_name != ""):
            if dir.current_is_dir():
#                print("Found directory: " + file_name)
                pass
            else:
#                print("Found file: " + file_name)
                ret.append(file_name)
            file_name = dir.get_next()
    else:
        print("An error occurred when trying to access the path.")
    return ret



# https://godotengine.org/qa/13029/is-there-a-corresponding-type-function-in-gdscript
func general_type_of(obj):
    var typ = typeof(obj)
    var builtin_type_names = ["nil", "bool", "int", "real", "string", "vector2", "rect2", "vector3", "maxtrix32", "plane", "quat", "aabb",  "matrix3", "transform", "color", "image", "nodepath", "rid", null, "inputevent", "dictionary", "array", "rawarray", "intarray", "realarray", "stringarray", "vector2array", "vector3array", "colorarray", "unknown"]

    if(typ == TYPE_OBJECT):
        obj.type_of()
    else:
        builtin_type_names[typ]


# https://godotdevelopers.org/forum/discussion/18970/how-can-i-work-with-binary-numbers
# Takes in a decimal value (int) and returns the binary value (int)
func dec2bin(var decimal_value):
    var binary_string = ""
    var temp
    var count = 31 # Checking up to 32 bits
    while(count >= 0):
        temp = decimal_value >> count
        if(temp & 1):
            binary_string = binary_string + "1"
        else:
            binary_string = binary_string + "0"
        count -= 1
#    return int(binary_string) #WARNING REMOVED, CONVERT LATER
    return binary_string

# Takes in a binary value (int) and returns the decimal value (int)
func bin2dec(var binary_value):
    var decimal_value = 0
    var count = 0
    var temp
    while(binary_value != 0):
        temp = binary_value % 10
        binary_value /= 10
        decimal_value += temp * pow(2, count)
        count += 1
    return decimal_value



"""
function ran_gaussian_2D()
    --http://www.design.caltech.edu/erik/Misc/Gaussian.html //like a circle guasian
    --WE NEED TO MAKE THESE AGAIN SO WE ADD RANDOM FUNCTION OURSELVES
    local r1, r2 = math.random(), math.random()
    x = math.sqrt(-2 * math.log(r1)) * math.cos(2 * math.pi * r2)
    y = math.sqrt(-2 * math.log(r1)) * math.sin(2 * math.pi * r2)
    return x, y
end
"""


func ran_gaussian_2D():
    """
    ported from the caltech lua one

    making some optimisations now, many bits are just repeated!

    STILL NEED TO FIGURE SOME OF THESE EQUATIONS OUT
    """
    var r1 = randf()
    var r2 = randf()

    var al1 = sqrt(-2 * log(r1)) # part one
    var al2 = 2 * PI * r2 # part two

    var x = al1 * cos(al2)
    var y = al1 * sin(al2)

    return Vector3(x,0,y)

func ran_gaussian_3D():
    var gaussian1 =  ran_gaussian_2D()
    var gaussian2 =  ran_gaussian_2D()
    gaussian1.y = gaussian2.x
    return gaussian1




#public static Vector3 ProjectOnPlane(Vector3 vector, Vector3 planeNormal);

const PositiveInfinity = 3.402823e+38
const NegativeInfinity = -2.802597e-45

func ProjectOnPlane(vector, planeNormal):
    """
    NOT WORKING
    """
    var projected = Plane(planeNormal, PositiveInfinity).project(vector)



"""
the collision dictionary contains my 16 bit scheme

each block of 4 bits is a team
the 1st of the block is the unit (player or enemy)
the 2nd are normal bullets that fly through (like plasma balls)
the 3rd are colliding bullets that hit other bullets (like missiles)
the 4th is reserved
all bits on is used for walls that collide with everything
"""
var coll_dict_data1 = [
    ["player",
    "1000000000000000", "0000111111111111"],
    ["playerbullet",
    "0100000000000000", "0000101110111011"],
    ["playerbulletclash",
    "0010000000000000", "0000111111111111"],
    ["enemy",
    "0000100000000000", "1111000011111111"],
    ["enemybullet",
    "0000010000000000", "1011000010111011"],
    ["enemybulletclash",
    "0000001000000000", "1111000011111111"],
    ["team3",
    "0000000010000000", "1111111100001111"],
    ["team3bullet",
    "0000000001000000", "1011101100001011"],
    ["team3bulletclash",
    "0000000000100000", "1111111100001111"],
    ["team4",
    "0000000000001000", "1111111111110000"],
    ["team4bullet",
    "0000000000000100", "1011101110110000"],
    ["team4bulletclash",
    "0000000000000010", "1111111111110000"],

    ["wall",
    "1111111111111111", "1111111111111111"],

    ["collision plane", # last bit of 20 for the 2D collision plane
    "00000000000000000001", "00000000000000000001"], #524288
    ["NOT collision plane",
    "11111111111111111110", "11111111111111111110"], #524287
]

var _coll_dict
func coll_dict():
    if not _coll_dict:
        var s = 'var coll_layer_dict = {'
        _coll_dict = {}
        for entry in coll_dict_data1:
            var name = entry[0]
            var layer = bin_string_to_number(entry[1])
            var mask = bin_string_to_number(entry[2])
            _coll_dict[name] = [layer,mask]
            s += "\n    %s: [%s, %s]," % [name,layer,mask]
        s += "\n}"
#        print("GENERATED COLL DICT:")
#        print(s)

    return _coll_dict



func bin_string_to_number(binstring):
    var ret = 0
    for n in range(len(binstring)):
        var char1 = binstring[n]
        if char1 == '1':
            ret += pow(2,n)
    return ret

func snap_to_grid(input_vector, grid_size = 2):
    input_vector.x = round(input_vector.x / grid_size)*grid_size
    input_vector.y = round(input_vector.y / grid_size)*grid_size
    input_vector.z = round(input_vector.z / grid_size)*grid_size
    return input_vector

# QUICK CHANGE COLOUR FUNCTIONS?

func set_color_of_sprite_3D(sprite3D):
    """
    how to set color of 3D sprite
    """
    var material = sprite3D.material_override
    material.albedo_color = Color(0, 0, 1)

func set_color_of_mesh_instance(mesh_instance):
    """
    how to set color of mesh
    """
    var material = mesh_instance.get_surface_material(0)
    material.albedo_color = Color(0, 0, 1) # blue shade

func ranchoice(array_in):
    return array_in[randi() % array_in.size()]

func get_2d_array(width, height, default_val = null):
    var matrix = []
    for x in range(width):
        var row = []
        for y in range(height):
            row.append(default_val)
        matrix.append(row)
    return matrix

func copy_2d_array(array):
    var ret = []
    for row in array:
        var newrow = []
        for val in row:
            newrow.append(val)
        ret.append(newrow)
    return ret

func csv_to_array(filename):
    var ret = []
    var f = File.new()
    f.open(filename, 1)
    while not f.eof_reached():
        var line = f.get_csv_line()
#        if line.size() > 1:
        ret.append(line)
    f.close()
    return ret

func csv_to_dicts(filename):
    var ret = []
    var f = File.new()
    var keys
    f.open(filename, 1)
    var index = 1
    while not f.eof_reached():
        var line = f.get_csv_line()
        if line.size() > 1:
            if index == 1: # first line is keys
                keys = line
            else:
                var dict = {}
                for i in range(keys.size()-1):
                    dict[keys[i]] = line[i]
                ret.append(dict)
        index += 1
    f.close()
    return ret

func load_csv_map_file(filename):
    """
    currently the map file is defined as a csv file ihe form:
        <map>
        1,1,,1,1
        1,,,,1
        <map>
        1,1,1
        1,,1
        1,1,1
        <map>
    """
    var empty_val = ''

    var dun_layouts_sheet = csv_to_array(filename)

    var ret = []
    var map_build
    var add_map = false
    for row in dun_layouts_sheet:
        if row.size() >= 1:
            if row[0] == '<map>':
                if map_build: #append last map
                    ret.append(map_build)
                    map_build = null
                add_map = true
                map_build = []
#                if row.size() > 1:
#                    print('hshshs key' , row[1])
#                    map_build.append([row[1]])
            else:
                if add_map:
                    row = Array(row) #prevents bugs appending rows
                    map_build.append(row)

    for map in ret:

        var max_width = 0 #find the maximum width of a row
        for row in map:
            if row.size() > max_width:
                max_width = row.size()

        for row in map: #ensure all rows match this width by padding the row
            while row.size() < max_width:
                row.append(empty_val)

    return ret

func load_keyed_csv_map_file(filename):
    var empty_val = ''

    var dun_layouts_sheet = csv_to_array(filename)

    var ret = []
    var map_build
    var add_map = false
    for row in dun_layouts_sheet:
        if row.size() >= 1:
            if row[0] == '<map>':
                if map_build: #append last map
                    ret.append(map_build)
                    map_build = null
                add_map = true
                map_build = []
#                if row.size() > 1:
#                    print('hshshs key' , row[1])
#                    map_build.append([row[1]])
            else:
                if add_map:
                    row = Array(row) #prevents bugs appending rows
                    map_build.append(row)

    for map in ret:

        var max_width = 0 #find the maximum width of a row
        for row in map:
            if row.size() > max_width:
                max_width = row.size()

        for row in map: #ensure all rows match this width by padding the row
            while row.size() < max_width:
                row.append(empty_val)

    return ret

func shuffle_list(list, _seed = null):
    list = list.duplicate()
    if _seed:
        seed(_seed)
    var shuffledList = []
    var indexList = range(list.size())
    for i in range(list.size()):
        var x = randi()%indexList.size()
        shuffledList.append(list[x])
        indexList.remove(x)
        list.remove(x)
    return shuffledList



func str_to_int(input):
    """
    convert a string to an int
    however if fails, rather than 0, return the input
    """
    if input == '0':
        return 0
    else:
        var ret = int(input)
        if ret == 0:
            return input
        else:
            return ret


# [ColorFunctions]

func HSVtoRGB (hue, saturation, luminance):
    """
    WORKS SO FAR BUT IT'S ALONE
    note i need backwards:
    https://www.laurivan.com/rgb-to-hsv-to-rgb-for-shaders/

    """
    var r = float(luminance)
    var g = float(luminance)
    var b = float(luminance)

    var v = 0.0

    if luminance <= 0.5:
        v = luminance * (1.0 + saturation)
    else:
        v = luminance + saturation - luminance * saturation

    if v > 0:
        var m = luminance + luminance - v
        var sv = (v - m) / v
        hue *= 6
        var sextant = int(hue)
        var fract = float(hue) - float(sextant)
        var vsf = v * sv * fract
        var mid1 = m + vsf
        var mid2 = v - vsf

        match sextant:
            0:
                r = v
                g = mid1
                b = m
            1:
                r = mid2
                g = v
                b = m
            2:
                r = m
                g = v
                b = mid1
            3:
                r = m
                g = mid2
                b = v
            4:
                r = mid1
                g = m
                b = v
            5:
                r = v
                g = m
                b = mid2
    return Color(r,g,b)




func list_max(list):
    var ret
    for val in list:
        if not ret:
            ret = val
        else:
            if val > ret:
                ret = val
    return ret

func list_min(list):
    var ret
    for val in list:
        if not ret:
            ret = val
        else:
            if val < ret:
                ret = val
    return ret


func hsv2rgb(hsvColor):
    """
    still not working



    http://code.activestate.com/recipes/576919-python-rgb-and-hsv-conversion/
    """
    var h = hsvColor[0]
    var s = hsvColor[1]
    var v = hsvColor[2]

    h *= 360.0
#    h = float(h)
#    s = float(s)
#    v = float(v)
    var h60 = h / 60.0
#    var h60f = math.floor(h60) #try convert to int
    var h60f = float(int(h60))
    var hi = int(h60f) % 6 #which sextant to go down!
    var f = h60 - h60f
    var p = v * (1 - s)
    var q = v * (1 - f * s)
    var t = v * (1 - (1 - f) * s)

    var r = 0.0
    var g = 0.0
    var b = 0.0
    if hi == 0:
        r=v
        g=t
        b=p
    elif hi == 1:
#        r, g, b = q, v, p
        r=q
        b=v
        g=p
    elif hi == 2:
#        r, g, b = p, v, t
        r=p
        g=v
        b=t
    elif hi == 3:
#        r, g, b = p, q, v
        r=p
        g=q
        b=v
    elif hi == 4:
#        r, g, b = t, p, v
        r=t
        g=p
        b=v
    elif hi == 5:
#        r, g, b = v, p, q
        r=v
        g=p
        b=q
#    r, g, b = int(r * 255), int(g * 255), int(b * 255)
    return Color(r, g, b)





func rgb2hsv(_color):
    """
    ported from
    http://code.activestate.com/recipes/576919-python-rgb-and-hsv-conversion/

    All HSV values are

    """
    var r = _color[0]
#    r/=255.0
    var g = _color[1]
#    g/=255.0
    var b = _color[2]
#    b/=255.0
    var mx = list_max([r, g, b])
    var mn = list_min([r, g, b])
    var df = mx-mn
    var h
    var s
    if mx == mn:
        h = 0.0
    elif mx == r:
        h = (60.0 * ((g-b)/df) + 360.0)
        h = fmod(h, 360.0)
    elif mx == g:
        h = (60.0 * ((b-r)/df) + 120.0)
        h = fmod(h, 360.0)
    elif mx == b:
        h = (60.0 * ((r-g)/df) + 240.0)
        h = fmod(h, 360.0)
    if mx == 0.0:
        s = 0.0
    else:
        s = df/mx
    h/=360.0 # MY CORRECTION (hue default mod is 360)
    return Color(h, s, mx)




func ShortToBytes(value):
    """
    for investigation and consolodation (not yet used)
    """
    # value: 16 bit INTEGER! [0 - 65535]
    var bytes = PoolByteArray()
    var X = value / 255
    bytes.append(value - X - 128) # are godot bytes signed or unsigned?
    bytes.append(X - 128)
    return bytes




func array_split(array, start = 0, end = -1):
    """
    stand in to cut array like python
    """
    var ret = []
    if end < 0:
        end = array.size() + end
    for i in range(array.size()):
        if i >= start and i<= end:
            ret.append(array[i])
    return ret



