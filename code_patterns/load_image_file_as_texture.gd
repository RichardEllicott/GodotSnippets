"""

this way causes errors for export...

instead load(_filename) returns a texture




"""



func load_file_as_texture(_filename):
    var tex = ImageTexture.new()
    var img = Image.new()
    img.load(_filename)
    tex.create_from_image(img)
    return tex
