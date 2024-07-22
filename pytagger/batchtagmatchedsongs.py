import os
import mutagen
import datetime

# import taglib

from mutagen.id3 import GRP1, GRID, APIC, ID3, TIT2, TALB, TPE1, TPE2, TCOM, TCON, TPUB, TSOP, TXXX, TYER, TDRC, TDAT, TDOR, ID3NoHeaderError, TEXT, USLT
from mutagen.mp3 import MP3
from mutagen.flac import FLAC, Picture


from recording import Recording
from databaseconnection import DatabaseConnection

from io import BytesIO
from PIL import Image

ALBUM_ART_PATH = "backup_album.jpg"

def getRecordingInfoByMusicId(music_id):
    with DatabaseConnection().get_connection() as conn:
        c = conn.execute(f"SELECT title, orchestra, singers, date, style, composer, author, label, lyrics, duplicate_count, soloist, director, audio_source FROM recordings WHERE music_id = '{music_id}'")
        recording = None
        for row in c:
            recording = Recording(music_id, row[0], row[1], row[2], row[10], row[11], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[12])
        c.close()
    return recording

def parse_date(date_str):
    # print('date: ' + date_str)
    # Extract year, month, and day as integers
    year = int(date_str[:4])
    month = int(date_str[4:6])
    day = int(date_str[6:])
    
    date_obj = datetime.date(year, month, day)    
    year_str = str(year)
    formatted_date_str = date_obj.isoformat()
    
    return year_str, formatted_date_str

def extract_album_art(song, apic_found=False):
    # Extract album art and store it
    if song.tags is not None:
        for tag in song.tags.values():
            if isinstance(tag, APIC):
                with open(ALBUM_ART_PATH, "wb") as img:
                    apic_found = True
                    img.write(tag.data)
                break
    song.save()

def update_tags(root_folder):
    for root, dirs, files in os.walk(root_folder):
        for file in files:

            if (not file.lower().endswith(('.mp3'))) and (not file.lower().endswith(('.flac'))):
                continue

            parts = file.split('__')
            rawdate = parts[0]
            year, fdate = parse_date(rawdate)
            music_id = parts[-1].split('.')[0]

            recording = getRecordingInfoByMusicId(music_id)
            if recording:
                label = recording.label.title() if recording.label != 'None' else ''
                composer = recording.composer.split(' y ') if recording.composer != 'None' else ''
                lyricist = recording.author.split(' y ') if recording.author != 'None' else ''
                first_artist = recording.orchestra.title() if recording.orchestra != 'None' else recording.soloist.title()
                second_artist = recording.singers.split(' y ') if recording.orchestra != 'None' else recording.director.title()

            file_path = os.path.join(root, file)
            if file.lower().endswith(('.mp3')):
                # print(f"mp3 - Updating tags for {file_path}")
                
                apic_found = False

                song = MP3(file_path, ID3=ID3)

                # Extract album art and store it
                if song.tags is not None:
                    for tag in song.tags.values():
                        if isinstance(tag, APIC):
                            with open(ALBUM_ART_PATH, "wb") as img:
                                apic_found = True
                                img.write(tag.data)
                            break
                # song.save()

                try:
                    mp3tags = ID3(file_path)
                except ID3NoHeaderError:
                    mp3tags = ID3()
                    mp3tags.save(file_path, v2_version=4)

                try: 
                    album = mp3tags['TALB']
                    mp3tags.delete()
                    
                    if apic_found:
                        with open(ALBUM_ART_PATH, "rb") as img:
                            album_art_data = img.read()

                            mp3tags['APIC'] = APIC(
                                encoding=3,
                                mime='image/jpeg',
                                type=3, 
                                desc='Front Cover',
                                data=album_art_data
                            )
                        mp3tags['TALB'] = album
                except KeyError:
                    print(f"KeyError: {file_path}")

                mp3tags['TIT2'] = TIT2(encoding=3, text=recording.title)
                mp3tags['TPE1'] = TPE1(encoding=3, text=', '.join(aa for aa in second_artist))
                mp3tags['TPE2'] = TPE2(encoding=3, text=first_artist)

                # mp3tags['TSOP'] = TSOP(encoding=3, text=os.path.basename(root))
                mp3tags['TXXX:ALBUMARTISTSORT'] = TXXX(encoding=3, desc='ALBUMARTISTSORT', text=os.path.basename(root))
                
                mp3tags['TCOM'] = TCOM(encoding=3, text=', '.join(aa for aa in composer))
                mp3tags['TCON'] = TCON(encoding=3, text=recording.style.title())
                mp3tags['TPUB'] = TPUB(encoding=3, text=label)

                if recording.orchestra == 'None' or (recording.orchestra != 'None' and second_artist != 'Instrumental'):
                    mp3tags['TEXT'] = TEXT(encoding=3, text=', '.join(aa for aa in lyricist))
                    mp3tags['USLT'] = USLT(encoding=3, text=recording.lyrics)
                    mp3tags['TXXX:UNSYNCEDLYRICS'] = TXXX(encoding=3, desc='UNSYNCEDLYRICS', text=recording.lyrics) # with mp3tag, it is USLT with Unix(LF)

                # mp3tags['GRID'] = GRID(encoding=3, text=recording.source)
                mp3tags['GRP1'] = GRP1(encoding=3, text=recording.source)
                mp3tags['TXXX:BARCODE'] = TXXX(encoding=3, desc='BARCODE', text="ERT-"+recording.id)

                mp3tags['TYER'] = TYER(encoding=3, text=year)
                mp3tags['TDRC'] = TDRC(encoding=3, text=fdate)
                mp3tags['TDOR'] = TDOR(encoding=3, text=fdate)

                # Save changes using ID3v2.4
                mp3tags.save(file_path, v2_version=4)

            elif file.lower().endswith(('.flac')):
                # print(f"flac - Updating tags for {file_path}")

                flac = FLAC(file_path)
                album = flac['album']

                if len(flac.pictures) > 1:
                    old_picture = flac.pictures[0]

                    flac.delete()
                    flac.clear_pictures()

                    old_picture.type = 3  # 3 is for front cover
                    old_picture.mime = "image/jpeg"  # or image/png
                    
                    flac.add_picture(old_picture)

                flac['title'] = recording.title
                flac['artist'] = ', '.join(aa for aa in second_artist)
                flac['albumartist'] = first_artist
                # flac['artistsort'] = os.path.basename(root)
                flac['albumartistsort'] = os.path.basename(root)
                flac['album'] = album
                flac['genre'] = recording.style.title()
                flac['composer'] = ', '.join(aa for aa in composer)
                flac['organization'] = label
                flac['grouping'] = recording.source
                flac['barcode'] = "ERT-"+recording.id
                flac['date'] = fdate
                flac['year'] = year
                flac['originaldate'] = fdate

                if recording.orchestra == 'None' or (recording.orchestra != 'None' and second_artist != 'Instrumental'):
                    flac["lyricist"] = ', '.join(aa for aa in lyricist)
                    flac["unsyncedlyrics"] = recording.lyrics  # FLAC, MP3

                flac.save()

            elif file.lower().endswith(('.m4a', '.aif')):
                print(f"WARNING => Skipping {file} in {root} because it is not an m4a or aif file")

if __name__ == "__main__":
    root_folder = '''xxx'''
    update_tags(root_folder)


# C:\\Users\\ext.dozen\\Music\\xxxProcessing\\tagged_test
# C:\\Users\\ext.dozen\\Music\\TT-TTT-tagged

