import os
from mutagen.mp3 import MP3
from mutagen.id3 import ID3, USLT, TXXX
from mutagen.flac import FLAC
from mutagen.id3 import ID3NoHeaderError
from databaseconnection import DatabaseConnection
from recording import Recording

def getRecordingInfoByMusicId(music_id):
    with DatabaseConnection().get_connection() as conn:
        c = conn.execute(f"SELECT title, orchestra, singers, date, style, composer, author, label, lyrics, duplicate_count, soloist, director, audio_source FROM recordings WHERE music_id = '{music_id}'")
        recording = None
        for row in c:
            recording = Recording(music_id, row[0], row[1], row[2], row[10], row[11], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[12])
        c.close()
    return recording

def add_lyrics_to_mp3(mp3_file_path, lyrics):
    try:
        audio = MP3(mp3_file_path, ID3=ID3)
    except ID3NoHeaderError:
        audio = MP3(mp3_file_path)
        audio.add_tags()

    uslt = USLT(encoding=3, text=lyrics)
    audio.tags.add(uslt)

    txxx = TXXX(encoding=3, desc='UNSYNCEDLYRICS', text=lyrics)
    audio.tags.add(txxx)

    audio.save()

def add_lyrics_to_flac(flac_file_path, lyrics):
    audio = FLAC(flac_file_path)
    audio['unsyncedlyrics'] = lyrics
    audio.save()

def process_files_in_folder(folder_path):
    for root, _, files in os.walk(folder_path):
        for file in files:
            if file.endswith('.mp3') or file.endswith('.flac'):
                file_path = os.path.join(root, file)
                music_id = extract_music_id(file_path)  # Implement this function based on your file naming convention

                # print('Music ID:', music_id)

                recording = getRecordingInfoByMusicId(music_id)

                # print('Recording:', recording.title, recording.lyrics[:20])
                
                if recording and recording.lyrics:
                    lyrics = recording.lyrics
                    if file.endswith('.mp3'):
                        add_lyrics_to_mp3(file_path, lyrics)
                    elif file.endswith('.flac'):
                        add_lyrics_to_flac(file_path, lyrics)

def extract_music_id(file_path):
    if file_path.endswith('.mp3'):
        try:
            audio = MP3(file_path, ID3=ID3)
            barcode_tag = audio.tags.getall('TXXX:BARCODE')
            if barcode_tag:
                barcode = barcode_tag[0].text[0]
                if barcode.startswith('ERT-'):
                    return barcode.replace('ERT-', '')
        except ID3NoHeaderError:
            return None
    elif file_path.endswith('.flac'):
        audio = FLAC(file_path)
        barcode = audio.get('barcode')
        if barcode:
            barcode = barcode[0]
            if barcode.startswith('ERT-'):
                return barcode.replace('ERT-', '')
    return None

# Example usage
folder_path = 'C:\\Users\\ext.dozen\\Music\\tc_tagged_soloists'
process_files_in_folder(folder_path)
