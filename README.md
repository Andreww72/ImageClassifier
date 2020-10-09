# egh444-group-project

## Image download and convert scripts

To setup the Python environment:

```
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt
```

To download external images of sydney and paris, and then get the 'other' images (images require manual sorting after this process):
```
python download_images.py
```

To convert jpgs to png once downloaded and sorted:
```
python convert_images.py <root_directory>
```