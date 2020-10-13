import os
import pathlib
import sys
import random
import numpy as np

import cv2

if __name__ == "__main__":

    try:
        input_dir = sys.argv[1]
        output_dir = sys.argv[2]
    except IndexError:
        print("Error: must provide input directory as first argument and output directory as second")
        sys.exit(1)

    random.seed(1) ## Seed so repeatable
    os.makedirs(output_dir, exist_ok=True)

    root = os.getcwd() # store this for later ;)

    os.chdir(input_dir)

    for subdir, dirs, files in os.walk('.'):
        for f in files:
            filepath = os.path.join(subdir, f)
            name, ext = os.path.splitext(f)
            if ext == ".png":
                angle = random.uniform(-180,180)
                pad_img = random.random() >= 0.5

                img = cv2.imread(filepath)
                try:
                    rows, cols, _ = img.shape
                except AttributeError:
                    print(f"{subdir}/{f} seems to be broken, skipping...")
                    continue
                
                if pad_img:
                    # make new image size
                    r = np.deg2rad(angle)
                    x, y = (abs(np.sin(r)*rows) + abs(np.cos(r)*cols),abs(np.sin(r)*cols) + abs(np.cos(r)*rows))
                else:
                    x, y = cols, rows
                
                print(f"Rotating {f} {angle} degrees...")

                # Get rotation matrix
                M = cv2.getRotationMatrix2D((cols/2,rows/2), angle, 1)

                if pad_img:
                    # Adjust translation or whatever
                    (tx,ty) = ((x-cols)/2, (y-rows)/2)
                    M[0,2] += tx
                    M[1,2] += ty

                # Rotate the image
                dst = cv2.warpAffine(img, M, (int(x),int(y)))
                
                # Write the result
                outfile = str(pathlib.PurePath(root, output_dir, subdir, "{}_{}.png".format(name, angle)))
                outdir, _ = os.path.split(outfile)
                os.makedirs(outdir, exist_ok=True)
                print(f"Writing to {outfile}...")
                cv2.imwrite(outfile, dst)
                
