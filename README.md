# egh444-group-project

## Image download and convert scripts

To setup the Python environment, run the following from the root of the project:

```
python3 -m venv env
source env/bin/activate
pip install -r utilities/requirements.txt
```

To download external images of sydney and paris, and then get the 'other' images (images require manual sorting after this process):
```
python utilities/download_images.py
```

To convert jpgs to png once downloaded and sorted:
```
python utilities/convert_images.py <root_image_directory>
```

To build the level 2 dataset from the downloaded images:
```
python utilities/rotate_images.py <source_image_root_dir> <output_image_root_dir>

e.g.

python utilities/rotate_images.py Images/Collected/Level1 Images/Collected/Level2
```