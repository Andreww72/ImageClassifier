import os
import random
import sys
import threading
import time

from wand.image import Image
from wand.color import Color
import numpy as np
import cv2 

def distort_img(input_file, output_dir):
    print("Distorting {}...".format(input_file))
    with Image(filename=input_file) as img:
        # Set virtual pixels to transparent
        img.virtual_pixel = 'transparent'

        # Create parameters for distortion
        a = random.uniform(0, 1)
        b = random.uniform(2, 5)
        c = random.uniform(6, 10)
        d = random.uniform(0, 10)
        total = a + b + c + d
        a = a / total
        b = b / total
        c = c / total
        d = d / total
        # Distort image
        img.distort('barrel', (a, b, c, d))

        # Crop out unnecessary transparent pixels
        # Start by finding which axis we're working in
        min_axis_size = min(img.size)
        if min_axis_size == img.size[0]:
            col_to_look = min_axis_size/2
            row_idx = 0
            while img[int(col_to_look), int(row_idx)] == Color(string='transparent'):
                row_idx += 1
            img.crop(0, row_idx, img.size[0], (img.size[1]-row_idx))
        elif min_axis_size == img.size[1]:
            row_to_look = min_axis_size/2
            col_idx = 0
            while img[int(col_idx), int(row_to_look)] == Color(string='transparent'):
                col_idx += 1
            img.crop(col_idx, 0, (img.size[0]-col_idx), img.size[1])
        
        location, filename = os.path.split(input_file)
        name, ext = os.path.splitext(filename)
        path, parent = os.path.split(location)
        os.makedirs(os.path.join(output_dir, parent), exist_ok=True)

        img.save(filename=os.path.join(output_dir, parent, "{}_distorted{}".format(name, ext)))

if __name__ == "__main__":
    try:
        input_dir = sys.argv[1]
        output_dir = sys.argv[2]
    except IndexError:
        print("Error: first argument must be input dir, second must be output dir")
        sys.exit(1)

    random.seed(1)
    image = None

    # Make output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)

    for subdir, dirs, files in os.walk(input_dir):
        for f in files:
            name, ext = os.path.splitext(f)
            if ext == ".png":
                # Open the image with wand
                while (threading.active_count() > 8):
                    time.sleep(1)
                threading.Thread(target=distort_img, args=(os.path.join(subdir,f), output_dir,)).start()