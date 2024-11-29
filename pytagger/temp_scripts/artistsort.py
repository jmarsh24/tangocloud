import os
import mutagen
from mutagen.id3 import ID3, TSOP
from mutagen.flac import FLAC

def update_artistsort(root_folder):
    # Walk through the root folder
    for subdir, _, files in os.walk(root_folder):
        # Extract the folder name to use as the artistsort value
        folder_name = os.path.basename(subdir)
        print(f"Processing folder: {folder_name}")
        for file in files:
            file_path = os.path.join(subdir, file)

            if file.lower().endswith('.mp3'):
                update_mp3_artistsort(file_path, folder_name)
            elif file.lower().endswith('.flac'):
                update_flac_artistsort(file_path, folder_name)

def update_mp3_artistsort(file_path, artistsort_value):
    try:
        audio = ID3(file_path)
        audio['TSOP'] = TSOP(encoding=3, text=artistsort_value)
        audio.save(file_path, v2_version=4)
        # print(f"Updated MP3: {file_path}")
    except mutagen.id3.ID3NoHeaderError:
        print(f"No ID3 header found in {file_path}. Skipping.")
    except Exception as e:
        print(f"Error updating MP3 {file_path}: {e}")

def update_flac_artistsort(file_path, artistsort_value):
    try:
        audio = FLAC(file_path)
        audio['artistsort'] = artistsort_value
        audio.save()
        # print(f"Updated FLAC: {file_path}")
    except Exception as e:
        print(f"Error updating FLAC {file_path}: {e}")

if __name__ == "__main__":
    root_folder = '''xxx'''
    update_artistsort(root_folder)
