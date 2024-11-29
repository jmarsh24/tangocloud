import os
from mutagen.mp3 import MP3
from mutagen.id3 import ID3, TXXX

# Path to the directory containing the music files
directory = "C:\\Users\\dogac\\Music\\xxNEW\\xxx"

def add_catalog_number_to_mp3(file_path, catalog_number):
    """Remove existing CatalogNumber tag and add a new one to an MP3 file."""
    audio = MP3(file_path, ID3=ID3)

    # Add the new CatalogNumber tag
    frame = TXXX(desc='CatalogNumber', text=catalog_number)
    audio.tags.add(frame)
    audio.save(v2_version=4)
    print(f"Added new CatalogNumber '{catalog_number}' to {file_path}")

# Process each file in the directory
for filename in os.listdir(directory):
    if filename.endswith(".mp3"):
        # Extract the TC code from the filename
        parts = filename.split("__")
        tc_code = next((part for part in parts if part.startswith("TC")), None)
        
        if tc_code:
            # Construct the full file path
            file_path = os.path.join(directory, filename)
            
            # Add the CatalogNumber tag
            add_catalog_number_to_mp3(file_path, tc_code)
