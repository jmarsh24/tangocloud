import os
from mutagen.id3 import ID3, TXXX
from mutagen.mp3 import MP3
from mutagen.flac import FLAC

NEXT_UNIQUE_ID = 8251 # Last used unique id is TC 8242

def add_catalog_number_to_mp3(file_path, catalog_number):
    audio = MP3(file_path, ID3=ID3)
    frame = TXXX(desc='CatalogNumber', text=catalog_number)
    audio.tags.add(frame)
    audio.save(v2_version=4)

def add_catalog_number_to_flac(file_path, catalog_number):
    audio = FLAC(file_path)
    audio['CatalogNumber'] = catalog_number
    audio.save()

def process_files_in_directory(directory):

    unique_id = NEXT_UNIQUE_ID

    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.lower().endswith(('.mp3', '.flac')):
                file_path = os.path.join(root, file)
                catalog_number = 'TC'+str(unique_id)

                # Add catalog number to the tags
                if file.lower().endswith('.mp3'):
                    add_catalog_number_to_mp3(file_path, catalog_number)
                elif file.lower().endswith('.flac'):
                    add_catalog_number_to_flac(file_path, catalog_number)

                # Rename the file
                base, ext = os.path.splitext(file)
                new_file_name = f"{base}__{catalog_number}{ext}"
                new_file_path = os.path.join(root, new_file_name)
                os.rename(file_path, new_file_path)

                print(f"Processed {file_path} -> {new_file_path} with CatalogNumber {catalog_number}")

                unique_id += 1

process_files_in_directory('C:\\Users\\dogac\\Music\\TTT12')
