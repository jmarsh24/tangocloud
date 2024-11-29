import os
from mutagen.id3 import ID3, TXXX
from mutagen.mp3 import MP3
from mutagen.flac import FLAC

def extract_catalog_number(file_name):
    """Extract the numeric catalog number from the part after the last underscore."""
    base_name = os.path.splitext(file_name)[0]  # Remove the file extension
    parts = base_name.split('_')  # Split by underscores
    if parts and parts[-2].startswith('TC'):
        # Extract the numeric part after 'TC'
        return parts[-2]  # Return everything after 'TC'
    return None

def add_catalog_number_to_mp3(file_path, catalog_number):
    """Add the CatalogNumber tag to an MP3 file."""
    audio = MP3(file_path, ID3=ID3)
    frame = TXXX(desc='CatalogNumber', text=catalog_number)
    audio.tags.add(frame)
    audio.save(v2_version=4)

def add_catalog_number_to_flac(file_path, catalog_number):
    """Add the CatalogNumber tag to a FLAC file."""
    audio = FLAC(file_path)
    audio['CatalogNumber'] = catalog_number
    audio.save()

def process_files_in_directory(directory):
    """Process MP3 and FLAC files in the directory tree."""
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.lower().endswith(('.mp3', '.flac')):
                file_path = os.path.join(root, file)
                catalog_number = extract_catalog_number(file)
                
                if not catalog_number:
                    print(f"Skipped {file} (No valid CatalogNumber found in filename)")
                    continue

                # Add catalog number to the tags
                if file.lower().endswith('.mp3'):
                    add_catalog_number_to_mp3(file_path, catalog_number)
                elif file.lower().endswith('.flac'):
                    add_catalog_number_to_flac(file_path, catalog_number)

                print(f"Processed {file_path} with CatalogNumber {catalog_number}")

process_files_in_directory('C:\\Users\\dogac\\Music\\xxNEW\\xNewlyTaggedWithErrors')
