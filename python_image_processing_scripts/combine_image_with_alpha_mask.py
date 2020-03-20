"""

using pil library

copies a main image's RGB channels to a new image, where the alpha has a copy of the 0 channel (likely R) of the alpha file


This means combining an albedo map with an alpha mask (typically an image that is whiter where less transparent, black for transparent)

Creating an Albedo Texture With Alpha



I wrote it for the annoying barbed wire on www.textures.com



NOTES: Sure this program is pretty slow, it takes a few seconds for one image due to iterating all pixels in python.
This is worth it because the code can be edited easily with little knowledge


"""

from __future__ import absolute_import, division, print_function

from PIL import Image

filename_main = "TexturesCom_Atlas_BarbedWire_512_albedo.png"
filename_alpha = "TexturesCom_Atlas_BarbedWire_512_alpha.png"
filename_output = "TexturesCom_Atlas_BarbedWire_512_albedoalpha.png"

input_image = Image.open(filename_main)
input_alpha_image = Image.open(filename_alpha)
output_image = Image.new('RGBA', (input_image.size[0], input_image.size[1]))

pixelsA = input_image.load()
pixelsB = input_alpha_image.load()

n = 0
for y in xrange(input_image.size[1]):
    for x in xrange(input_image.size[0]):
        pixelA = pixelsA[x, y]
        pixelB = pixelsB[x, y]
        new_pixel = (pixelA[0], pixelA[1], pixelA[2], pixelB[0])  # create new pixel using the 0 channel of image B as an alpha

        output_image.putpixel((x, y), new_pixel)  # save pixel


output_image.save(filename_output, "PNG")

print("saved file to: ", filename_output)
