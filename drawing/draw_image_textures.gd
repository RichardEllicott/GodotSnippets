"""


working example of drawing an image in code and loading a texture from it

"""



export(Image) var _image : Image
export(ImageTexture) var _texture : ImageTexture


func draw_image_texture_example():
    
    # working min example 2022

    _image = Image.new()
    _image.create(1024,1024,false,Image.FORMAT_RGBA8)
        
    _image.lock()
    
    _image.fill(Color.blue)

    _image.set_pixel(1, 1, Color.red) # set one pixel
    
    _image.unlock()
    
    _texture = ImageTexture.new()

    _texture.create_from_image(_image)
    #_texture.create_from_image(_image, Texture.FLAGS_FILTER | Texture.FLAGS_REPEAT)
    
    
    pass








var _image : Image

var image_size = Vector2(1024,1024)

func get_image():
    if not _image:
        _image = Image.new()
        _image.create(image_size.x,image_size.y,false,Image.FORMAT_RGBA8)
    return _image


func image_set_pixel(x,y,val):
    get_image()    
    _image.lock()
    _image.set_pixel(1, 1, val)
    _image.unlock()

    

func image_get_pixel(x,y):
    get_image()
    _image.lock()
    var val = _image.get_pixel(x, y)
    _image.unlock()
    return val
