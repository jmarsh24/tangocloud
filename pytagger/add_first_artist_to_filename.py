import os
import mutagen
import datetime
import unicodedata

# import taglib
from mutagen.mp3 import MP3
from mutagen.id3 import GRID, APIC, ID3, TIT2, TALB, TPE1, TPE2, TBPM, TCOM, TCON, TLEN, TPUB, TSOP, TXXX, TYER, TDRC, TDAT, TDOR, ID3NoHeaderError, TORY, TEXT, USLT
from mutagen.flac import FLAC

from recording import Recording
from databaseconnection import DatabaseConnection
from unidecode import unidecode
from io import BytesIO
from PIL import Image

def getRecordingInfoByMusicId(music_id):
    with DatabaseConnection().get_connection() as conn:
        c = conn.execute(f"SELECT title, orchestra, singers, date, style, composer, author, label, lyrics, duplicate_count, soloist, director, audio_source FROM recordings WHERE music_id = '{music_id}'")
        recording = None
        for row in c:
            recording = Recording(music_id, row[0], row[1], row[2], row[10], row[11], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[12])
        c.close()
    return recording

def remove_accents(input_str):
    # Normalize the string to NFD (Normalization Form D) to decompose characters
    nfkd_form = unicodedata.normalize('NFD', input_str)
    # Filter out the combining characters (marks)
    return ''.join([char for char in nfkd_form if not unicodedata.combining(char)])

def modify_string(original_string, insert_string):
    parts = original_string.split('__')
    parts.insert(1, insert_string)    
    modified_string = '__'.join(parts)
    
    return modified_string

def update_tags(root_folder):
    for root, dirs, files in os.walk(root_folder):
        for file in files:

            parts = file.split('__')
            music_id = parts[-1].split('.')[0]

            file_path = os.path.join(root, file)

            recording = getRecordingInfoByMusicId(music_id)
            if recording:
                if recording.orchestra != 'None':
                    new_file_path = modify_string(file, recording.orchestra.replace(' ', '_'))
                else:
                    new_file_path = modify_string(file, recording.soloist.replace(' ', '_'))
                os.rename(file_path, os.path.join(root, remove_accents(new_file_path.lower())))

def remove_tirets(root_folder):
    for root, dirs, files in os.walk(root_folder):
        for file in files:
            new_file = file.replace('-', '_')
            os.rename(os.path.join(root, file), os.path.join(root, new_file))

if __name__ == "__main__":
    root_folder = '''C:\\Users\\ext.dozen\\Music\\TT-TTT-tagged\\Francini-Pontier'''
    remove_tirets(root_folder)