import os
import pathlib
import sys

import numpy as np
import cv2

if __name__=="__main__":
    try:
        input_dir = sys.argv[1]
        output_dir = sys.argv[2]
    except IndexError:
        print("Error: must provide input directory as first argument and output directory as second")

    random.seed(1)
    os.makedirs(output_dir, exist_ok=True)

    root = os.getcwd()
    os.chdir(input_dir)

    for subdir, dirs, files in os.walk('.'):
        for f in files:
            filepath = os.path.join(subdir, f)
            name, ext = os.path.splitext(f)
            if ext == ".png":
                ## Perform processing