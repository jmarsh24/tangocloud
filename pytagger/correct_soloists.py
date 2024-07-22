import os
import mutagen
import datetime

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

def update_filenames(root_folder):
    for root, dirs, files in os.walk(root_folder):
        for file in files:

            parts = file.split('__')
            music_id = parts[-1].split('.')[0]

            file_path = os.path.join(root, file)

            recording = getRecordingInfoByMusicId(music_id)
            if recording:
                new_file = file.replace('__none__', '__' + unidecode(recording.director.lower()).replace('dir. ', '').replace(' ', '_') + '__')
                new_file_path = os.path.join(root, new_file)
                os.rename(file_path, new_file_path)

if __name__ == "__main__":
    root_folder = '''xxx'''
    update_filenames(root_folder)