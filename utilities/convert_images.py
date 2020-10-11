import sys
import os
import threading
import time

from PIL import Image

def convert_image(input_file):
    '''
    Convert provided image from jpg to png
    '''
    name, ext = os.path.splitext(f)
    location, filename = os.path.split(input_file)
    print("Converting {} to {}".format(input_file, os.path.join(location, "{}.png".format(name))))
    im = Image.open(input_file)
    im.convert('RGB').save(os.path.join(location, "{}.png".format(name)))
    
    # delete old image
    os.remove(input_file)

if __name__ == "__main__":
    try:
        root = sys.argv[1]
    except IndexError:
        print("Error: must provide root directory as first argument. ")
        sys.exit(1)

    # Cycle through files
    for subdir, dirs, files in os.walk(os.path.join(os.getcwd(), root)):
        for f in files:
            # Get the file extension
            name, ext = os.path.splitext(f)
            # Is it a png?
            if ext in ('.jpg', '.jpeg'):
                # Wait for threads to be available (max 8)
                # Create thread
                while (threading.active_count() > 8):
                    time.sleep(1)
                threading.Thread(target=convert_image, args=(os.path.join(subdir, f),)).start()