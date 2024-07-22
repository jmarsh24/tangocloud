import os
import csv
from mutagen.id3 import ID3
from mutagen.mp3 import MP3
from mutagen.flac import FLAC

def read_tags(root_folder):
    data = []
    headers = [
        'filename', 'title', 'artist', 'albumartist', 'albumartistsort', 'album', 'composer', 'genre', 
        'publisher', 'lyricist', 'grouping', 'barcode', 'originaldate', 'catalognumber',
        'REPLAYGAIN_TRACK_GAIN', 'REPLAYGAIN_TRACK_PEAK',
        'lyrics'
    ]

    for root, dirs, files in os.walk(root_folder):
        for file in files:
            if not (file.lower().endswith('.mp3') or file.lower().endswith('.flac')):
                continue

            file_path = os.path.join(root, file)
            tags = {'filename': os.path.basename(file_path)}

            if file.lower().endswith('.mp3'):
                song = MP3(file_path, ID3=ID3)
                mp3tags = song.tags
                if mp3tags is not None:
                    tags['title'] = mp3tags.get('TIT2', [''])[0]
                    tags['artist'] = mp3tags.get('TPE1', [''])[0]
                    tags['albumartist'] = mp3tags.get('TPE2', [''])[0]
                    tags['albumartistsort'] = mp3tags.get('TXXX:ALBUMARTISTSORT', [''])[0]
                    tags['album'] = mp3tags.get('TALB', [''])[0]
                    tags['composer'] = mp3tags.get('TCOM', [''])[0]
                    tags['genre'] = mp3tags.get('TCON', [''])[0]
                    tags['publisher'] = mp3tags.get('TPUB', [''])[0]
                    tags['lyricist'] = mp3tags.get('TEXT', [''])[0]
                    tags['grouping'] = mp3tags.get('GRP1', [''])[0]
                    tags['barcode'] = mp3tags.get('TXXX:BARCODE', [''])[0]
                    tags['originaldate'] = mp3tags.get('TDOR', [''])[0]
                    tags['catalognumber'] = mp3tags.get('TXXX:CatalogNumber', [''])[0]

                    tags['REPLAYGAIN_TRACK_GAIN'] = mp3tags.get('TXXX:REPLAYGAIN_TRACK_GAIN', [''])[0]
                    tags['REPLAYGAIN_TRACK_PEAK'] = mp3tags.get('TXXX:REPLAYGAIN_TRACK_PEAK', [''])[0]

                    tags['lyrics'] = mp3tags.get('TXXX:UNSYNCEDLYRICS', [''])[0].replace('\n', ' ').replace('\r', ' ')

                    # print(tags['REPLAYGAIN_TRACK_GAIN'])
                    # print(tags['REPLAYGAIN_TRACK_PEAK'])
                    # print(tags['lyrics'])

            elif file.lower().endswith('.flac'):
                flac = FLAC(file_path)
                tags['title'] = flac.get('title', [''])[0]
                tags['artist'] = flac.get('artist', [''])[0]
                tags['albumartist'] = flac.get('albumartist', [''])[0]
                tags['albumartistsort'] = flac.get('albumartistsort', [''])[0]
                tags['album'] = flac.get('album', [''])[0]
                tags['composer'] = flac.get('composer', [''])[0]
                tags['genre'] = flac.get('genre', [''])[0]
                tags['publisher'] = flac.get('organization', [''])[0]
                tags['lyricist'] = flac.get('lyricist', [''])[0]
                tags['grouping'] = flac.get('grouping', [''])[0]
                tags['barcode'] = flac.get('barcode', [''])[0]
                tags['originaldate'] = flac.get('originaldate', [''])[0]
                tags['catalognumber'] = flac.get('catalognumber', [''])[0]

                tags['REPLAYGAIN_TRACK_GAIN'] = flac.get('REPLAYGAIN_TRACK_GAIN', [''])[0]
                tags['REPLAYGAIN_TRACK_PEAK'] = flac.get('REPLAYGAIN_TRACK_PEAK', [''])[0]

                tags['lyrics'] = flac.get('unsyncedlyrics', [''])[0].replace('\n', ' ').replace('\r', ' ')

                # print(tags['REPLAYGAIN_TRACK_GAIN'])
                # print(tags['REPLAYGAIN_TRACK_PEAK'])
                # print(tags['lyrics'])

            data.append(tags)

    return headers, data

def write_to_csv(headers, data, output_csv):
    with open(output_csv, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=headers)
        writer.writeheader()
        for row in data:
            writer.writerow(row)

if __name__ == "__main__":
    root_folder = "C:\\Users\\ext.dozen\\Music\\tc_tagged_library"
    output_csv = "output_tags.csv"
    headers, data = read_tags(root_folder)
    write_to_csv(headers, data, output_csv)
    print(f"Tags written to {output_csv}")




