import csv
import os
import threading
import random
import sys

import requests

soh_id = "55350"
et_id = "47378"

sydney_dl = os.path.join('Images', 'Collected', 'Level1', 'Sydney')
paris_dl = os.path.join('Images', 'Collected', 'Level1', 'Paris')
other_dl = os.path.join('Images', 'Collected', 'Level1', 'Other')

def download_img(link, filename, filedir):
    # Download image
    try:
        r = requests.get(link)
    except requests.exceptions.ConnectionError:
        print("Skipping...")
        return

    # Write image to file
    print(f"Writing file {filename} from {link}")
    with open(os.path.join(filedir, filename), 'wb') as img:
        img.write(r.content)

if __name__ == "__main__":
    try:
        num_other_images = sys.argv[1]
    except IndexError:
        print("Error - must provide number of 'other' images as argument")
        sys.exit(1)

    # Download the training dataset
    files = os.listdir(os.getcwd())
    if 'train.csv' not in files:
        print("Downloading train.csv...")
        r = requests.get('https://s3.amazonaws.com/google-landmark/metadata/train.csv')

        with open('train.csv', 'wb') as csvfile:
            csvfile.write(r.content)
    else:
        print("Already found train.csv.")

    # Get our list of images
    sydney_img = []
    paris_img  = []
    with open('utilities/paris.txt', 'r') as paris_img_file:
        for line in paris_img_file:
            name, ext = os.path.splitext(line)
            paris_img.append(name)
    with open('utilities/sydney.txt', 'r') as sydney_img_file:
        for line in sydney_img_file:
            name, ext = os.path.splitext(line)
            sydney_img.append(name)

    # Create the image folders (keep separate for now :))
    if not os.path.exists(sydney_dl):
        os.makedirs(sydney_dl)
    if not os.path.exists(paris_dl):
        os.makedirs(paris_dl)
    if not os.path.exists(other_dl):
        os.makedirs(other_dl)
    
    other_images = []

    # Cycle through training dataset and get images
    with open('train.csv', newline='') as csvfile:
        csvreader = csv.reader(csvfile)

        for row in csvreader:
            if row[2] == "55350":
                # SYDNEY OPERA HOUSE
                if row[0] in sydney_img:
                    download_img(row[1], f'{row[0]}.jpg', sydney_dl)
                else:
                    print("Skipping Sydney image...")

            elif row[2] == "47378":
                # EIFFEL TOWER
                if row[0] in paris_img:
                    download_img(row[1], f'{row[0]}.jpg', paris_dl)
                else:
                    print("Skipping Paris image...")

            else:
                other_images.append(row)

    random.seed(1)
    random_choices = random.sample(other_images, int(num_other_images))

    for row in random_choices:
        # Don't download if its a Opera House or Eiffel Tower image
        if row[2] not in ("55350", "47378"):
            download_img(row[1], f'{row[0]}.jpg', other_dl)