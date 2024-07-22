import os
import sqlite3
from mutagen.id3 import ID3
from mutagen.flac import FLAC 

def update_source(album_name):
    if 'Su Obra Completa' in album_name:
        source = 'Free'
    elif 'TTT' in album_name:
        source = 'TTT'
    elif 'TT' in album_name:
        source = 'TT'
    else:
        source = 'Free'
    return source

def get_audio_metadata(file_path):
    if file_path.endswith('.mp3'):
        audio = ID3(file_path)
        album = audio.get('TALB', ['Unknown'])[0]
    elif file_path.endswith('.flac'):
        audio = FLAC(file_path)
        album = audio.get('album', ['Unknown'])[0]
    else:
        album = 'Unknown'
    return album

def parse_filename(filename):
    parts = filename.rsplit('__', 1)
    if len(parts) == 2:
        return parts[1].rsplit('.', 1)[0]
    return None

def update_database_record(unique_id, album):
    audio_source = update_source(album)
    print(unique_id, audio_source, album)

    db_path='tangotagger_v1.db'
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    cursor.execute("UPDATE recordings SET audio_source = ? WHERE music_id = ?", (audio_source, unique_id))
    conn.commit()
    conn.close()

def process_audio_files(folder_path):
    for root, _, files in os.walk(folder_path):
        for file in files:
            if file.endswith('.mp3') or file.endswith('.flac'):
                file_path = os.path.join(root, file)
                album = get_audio_metadata(file_path)
                unique_id = parse_filename(file)

                if unique_id:
                    update_database_record(unique_id, album)
                    print(f"Updated record for ID {unique_id} with album {album}")


folder_path = 'C:\\Users\\ext.dozen\\Music\\tc-tagged'
process_audio_files(folder_path)
