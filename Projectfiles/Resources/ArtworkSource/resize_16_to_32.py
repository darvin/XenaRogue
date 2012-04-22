from PIL import Image
import glob, os
from PIL.Image import FLIP_LEFT_RIGHT
import re
pattern = re.compile(r"^(.+)_e(_.+)?$")

for infile in glob.glob("_Sprites_16/*.png"):
    im = Image.open(infile)
    new_size = (im.size[0]*2, im.size[1]*2)
    im = im.resize(new_size)
    infile = os.path.join("_Sprites", os.path.basename(infile))
    im.save(infile)
    print "Resized: {}".format(infile)