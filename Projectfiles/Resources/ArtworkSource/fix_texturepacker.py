import Image
import os

def crop(infile,height,width):
    im = Image.open(infile)
    imgwidth, imgheight = im.size
    for i in range(imgheight//height):
        for j in range(imgwidth//width):
            box = (j*width, i*height, (j+1)*width, (i+1)*height)
            yield im.crop(box)


def difference(img1, img2):
    if img1.size != img2.size or img1.getbands() != img2.getbands():
        return -1

    s = 0
    for band_index, band in enumerate(img1.getbands()):
        m1 = numpy.array([p[band_index] for p in img1.getdata()]).reshape(*img1.size)
        m2 = numpy.array([p[band_index] for p in img2.getdata()]).reshape(*img2.size)
        s += numpy.sum(numpy.abs(m1-m2))
    return s
    
    
