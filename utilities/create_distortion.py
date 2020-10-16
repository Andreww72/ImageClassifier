import os
import random
import sys

from wand.image import Image
import numpy as np
import cv2 

if __name__ == "__main__":
    try:
        input_dir = sys.argv[1]
        output_dir = sys.argv[2]
    except IndexError:
        print("Error: first argument must be input dir, second must be output dir")
        sys.exit(1)

    random.seed(1)

    for subdir, dirs, files in os.walk(input_dir):
        for f in files:
            name, ext = os.path.splitext(f)
            if ext == ".png":
                # Open the image with wand
                with Image(filename=os.path.join(subdir, f)) as img:
                    img.virtual_pixel = 'transparent' #? ngl
                    a = random.uniform(0, 1)
                    b = random.uniform(0, 1)
                    c = random.uniform(0, 1)
                    d = random.uniform(0, 1)
                    img.distort('barrel', (a, b, c, d))
                    img.save(filename='test.png')