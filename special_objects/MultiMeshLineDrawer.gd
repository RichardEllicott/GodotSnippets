"""

"MultiMeshLineDrawer" object by Richard Ellicott 30/05/2022 (license: public domain or MIT)


script includes auto-setup function that will set up it's own multimesh



This object can draw multiple lines from a stretching and arranging multimesh instances

thusly it is somewhat similar to a line renderer in Unity, but uses geometry



see "example01" method for a simple example
see "autosetup" for notes about manual setup of the multimesh and the required settings for that


-this object has been kept deliberatly lightweight, it is suggested to "extend" it

-also though you could interact with it as a child of another object



"""
tool
extends MultiMeshInstance
class_name MultiMeshLineDrawer




func example01():
    autosetup() # running autosetup will ensure the object is set up correctly
    multimesh.instance_count = 1 # you need to set the amount of required instances in advance
    set_line_instance(0,Vector3(),Vector3(0,4,0)) # make a vertical line 4 units long
    multimesh.set_instance_color(0,Color.red) # set the line as red
    
func autosetup():
    
    """
    
    will automaticly load a multimesh if missing, set the default parameters
    add a CylinderMesh if required with some default material values
    
    this allows this script to set itself up
    concider adding a custom mesh for more fine control (like a tube instead of cylinder)
    
    
    In the case of using a custom mesh:
        -the mesh must be of dimensions 1x1x1
        -the mesh must represent a line from (0,0,0) to (1,0,0)
            -that is like a cylinder along the x axis by one unit
        
    using a tube mesh, that is a cylinder (8 sides is a good idea), with no end faces
    choose smooth shading
    this mesh is the most optimal as when using transparency the cylinder can look segmented
    
    
    """
    
    if not is_instance_valid(multimesh): # if no multimesh yet
        
        # note these default values are required of the multimesh:        
        multimesh = MultiMesh.new()
        multimesh.color_format = MultiMesh.COLOR_8BIT # required for vertex colours
        multimesh.transform_format = MultiMesh.TRANSFORM_3D # we only support 3D
        
    if not is_instance_valid(multimesh.mesh): # if no mesh attached
        
        var cylinder = CylinderMesh.new() # create our cylinder
        cylinder.rings = 0 # rings just waste polygons
        cylinder.radial_segments = 8 # 8 sides is fine
        multimesh.mesh = cylinder

        var mat = SpatialMaterial.new() # add a new spatial material
        mat.flags_unshaded = true # unshaded (not affected by shadows/fog)
        mat.vertex_color_use_as_albedo = true # this is required for colors
        mat.flags_transparent = true # allows the colors to be transparent
        cylinder.material = mat

func set_instance_count(count):
    autosetup()
    multimesh.instance_count = count


func set_line_instance_color(i, color):
    """
    function kept for notes
    
    this is how you set a line's color, you could just write this line
    
    """
    multimesh.set_instance_color(i,color)

func set_line_instance(i,from,to,width = 1.0, color = null):
    """
    
    a mesh instance will be stretched into position to make a line in 3D space
    
    make sure the required amount of instances are set in advance
        
    """
    
    var start_trans = Transform()
    
    if multimesh.mesh is CylinderMesh: # if we used a built in CylinderMesh, so autosetup ran
        start_trans = start_trans.rotated(Vector3(0,0,1), deg2rad(90))
        start_trans.origin.x += 1
        start_trans = start_trans.scaled(Vector3(0.5,0.5,0.5))
   
    var final_trans = _calc_line_transform(to-from,from,width,start_trans)
     
    multimesh.set_instance_transform (i,final_trans)
    
    if color != null:
        set_line_instance_color(i,color)
        
        
        

static func _calc_line_transform(_mag_vector: Vector3, _offset: Vector3 ,_width: float, trans = Transform()) -> Transform:
    """
    
    _calc_line_transform
    v1.0 (30/05/2022)
    
    
    this calculates a final transform to rotate a cylinder,
    all the maths is hidden here
    
    this cylinder goes from (0,0,0) to (1,0,0)
    
    so it is basicly 1 unit long along the x axis
    
    WARNING:
        the maths in this simple project took a while to figure out and had many changes
        unfortunatly so some of the logic of the acos
        
        some of the corrections avoids entering 0 into a divion or atan
        
        basicly created with some trial and error so the notes are incomplete


    to use this as a to and from:
    
    _mag_vector = to - from
    _offset = from

    """

    var mag_vector_copy = _mag_vector # correcting backwards bug (UNSURE STILL
    mag_vector_copy.x = -mag_vector_copy.x
    mag_vector_copy.z = -mag_vector_copy.z

#    var trans = Transform() # our transform matrix
    
    # stretch to the right length
    trans = trans.scaled(Vector3(mag_vector_copy.length(),_width,_width))
    
    var A = sqrt(pow(mag_vector_copy.x, 2.0) + pow(mag_vector_copy.z,2.0))
    #only rotate 2nd time if y is not 0, this elimnates a scene destroying bug!
    
    # rotate the on the z axis as the pitch
    if mag_vector_copy.y != 0.0: # avoids a bug? (no pitch required if no y on mag_vector)
        var H = mag_vector_copy.length()
        var theta = acos(A/H)
        if mag_vector_copy.y < 0.0: # WEIRD CORRECTION!!
            theta = -theta
    
        trans = trans.rotated(Vector3(0.0,0.0,1.0), theta)
        
    # rotate around the horizon as the direction (needs to be second rotation)
    trans = trans.rotated(Vector3.UP,atan2(mag_vector_copy.z,-mag_vector_copy.x))
    
    # this moves the offset (ignoring the scale and rotation), done last
    trans.origin += _offset 

    return trans

