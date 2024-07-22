import os
import re
import mutagen
from mutagen.id3 import ID3, TIT2
from mutagen.flac import FLAC

# Regular expression to match (1), (2), ..., (9) in filenames and tags
pattern = re.compile(r'_\(\d\)')
pattern2 = re.compile(r'\(\d\)')

def contains_digit_in_parentheses(filename):
    # Regular expression to match (1), (2), ..., (9) in filenames
    pattern = re.compile(r'_\(\d\)')
    # Search for the pattern in the filename
    return bool(pattern.search(filename))

def update_titles_and_filenames(root_folder):
    # Walk through the root folder
    for subdir, _, files in os.walk(root_folder):
        for file in files:
            file_path = os.path.join(subdir, file)
            # print(f"Processing file: {file_path}")
            if file.lower().endswith('.mp3'):
                update_mp3_file(file_path)
            elif file.lower().endswith('.flac'):
                update_flac_file(file_path)

def update_mp3_file(file_path):
    try:
        audio = ID3(file_path)
        new_title = pattern2.sub('', audio['TIT2'][0]).strip()
        audio['TIT2'] = TIT2(encoding=3, text=new_title)
        audio.save(file_path, v2_version=4)

        # Rename the file if it matches the pattern
        new_file_path = pattern.sub('', file_path)
        if new_file_path != file_path:
            os.rename(file_path, new_file_path)
            print(f"Renamed and updated MP3: {new_file_path}")
        else:
            print(f"Updated MP3: {file_path}")

    except mutagen.id3.ID3NoHeaderError:
        print(f"No ID3 header found in {file_path}. Skipping.")
    except Exception as e:
        print(f"Error updating MP3 {file_path}: {e}")

def update_flac_file(file_path):
    try:
        audio = FLAC(file_path)
        new_title = pattern2.sub('', audio['title'][0]).strip()
        audio['title'] = new_title
        audio.save()

        # Rename the file if it matches the pattern
        new_file_path = pattern.sub('', file_path)
        if new_file_path != file_path:
            os.rename(file_path, new_file_path)
            print(f"Renamed and updated FLAC: {new_file_path}")
        else:
            print(f"Updated FLAC: {file_path}")

    except Exception as e:
        print(f"Error updating FLAC {file_path}: {e}")

if __name__ == "__main__":
    root_folder = '''C:\\Users\\ext.dozen\\Music\\tc-tagged-soloists'''
    update_titles_and_filenames(root_folder)
