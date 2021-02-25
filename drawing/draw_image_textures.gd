


var image = $Sprite.texture.get_data()
image.unlock()

image.fill(Color(1,0,0,1)) # fill the image

image.lock()

image.set_pixel(2,2,Color.blue)

var imageTexture = ImageTexture.new()
imageTexture.create_from_image(image)
$Sprite.texture = imageTexture