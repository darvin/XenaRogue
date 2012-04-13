from PIL import Image
import glob, os
from PIL.Image import FLIP_LEFT_RIGHT
import re
pattern = re.compile(r"^(.+)_e(_.+)?$")

for infile in glob.glob("_Sprites/*.png"):
    file, ext = os.path.splitext(infile)
    match = pattern.match(file)
    if match:
        im = Image.open(infile)
        im = im.transpose(FLIP_LEFT_RIGHT)
        matched = list(match.groups())
        if not matched[1]:
            matched[1]=""
        outfile = ("%s_w%s" %  tuple(matched))+ext
        im.save(outfile)
        print "Flipped: {} to {}".format(infile, outfile)