import csv
import os
import threading

import requests

soh_id = "55350"
et_id = "47378"

sydney_dl = os.path.join('Images', 'Level_1', 'Downloaded_Sydney')
paris_dl = os.path.join('Images', 'Level_1', 'Downloaded_Paris')

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

    # Download the training dataset
    files = os.listdir(os.getcwd())
    if 'train.csv' not in files:
        print("Downloading train.csv...")
        r = requests.get('https://s3.amazonaws.com/google-landmark/metadata/train.csv')

        with open('train.csv', 'wb') as csvfile:
            csvfile.write(r.content)

    else:
        print("Already found train.csv.")

    # Create the image folders (keep separate for now :))
    if not os.path.exists(sydney_dl):
        os.makedirs(sydney_dl)
    if not os.path.exists(paris_dl):
        os.makedirs(paris_dl)
    
    # Cycle through training dataset and get images
    with open('train.csv', newline='') as csvfile:
        csvreader = csv.reader(csvfile)
        for row in csvreader:
            if row[2] == "55350":

                # SYDNEY OPERA HOUSE
                download_img(row[1], f'{row[0]}.jpg', sydney_dl)

            elif row[2] == "47378":
                
                # EIFFEL TOWER
                download_img(row[1], f'{row[0]}.jpg', paris_dl)