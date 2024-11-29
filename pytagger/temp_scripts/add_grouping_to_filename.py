import os
from mutagen.id3 import ID3, GRID, GRP1, TXXX, ID3NoHeaderError
from mutagen.mp3 import MP3
from mutagen.flac import FLAC

def update_grouping(album_name):
    if 'Tango Time Travel' in album_name:
        grouping = 'TTT'
    elif 'Tango Tunes' in album_name:
        grouping = 'TT'
    else:
        grouping = 'FREE'
    return grouping

def update_tags_and_rename(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            if file.lower().endswith('.mp3'):
                update_and_rename_mp3(file_path)
            elif file.lower().endswith('.flac'):
                update_and_rename_flac(file_path)

def update_and_rename_mp3(file_path):
    try:
        audio = MP3(file_path, ID3=ID3)
        if 'GRP1' in audio:
            album_name = audio['GRP1'][0]
            if album_name:
                new_file_name = add_grouping_to_filename(file_path, album_name)
                os.rename(file_path, new_file_name)
                print(f"Renamed MP3: {file_path} to {new_file_name}")
    except ID3NoHeaderError:
        print(f"No ID3 header found in {file_path}, skipping.")
    except Exception as e:
        print(f"Error processing {file_path}: {e}")

def update_and_rename_flac(file_path):
    try:
        audio = FLAC(file_path)
        if 'grouping' in audio:
            album_name = audio['grouping'][0]
            if album_name:
                new_file_name = add_grouping_to_filename(file_path, album_name)
                os.rename(file_path, new_file_name)
                print(f"Renamed FLAC: {file_path} to {new_file_name}")
    except Exception as e:
        print(f"Error processing {file_path}: {e}")

def add_grouping_to_filename(file_path, album_name):

    grp = update_grouping(album_name)

    directory, file_name = os.path.split(file_path)
    name, ext = os.path.splitext(file_name)
    new_name = f"{name}_{grp}{ext}"
    return os.path.join(directory, new_name)

if __name__ == "__main__":
    update_tags_and_rename("C:\\Users\\ext.dozen\\Music\\tc_tagged_library")
