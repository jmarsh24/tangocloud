import os
from mutagen.easyid3 import EasyID3
from mutagen.flac import FLAC
from mutagen.id3 import ID3, ID3NoHeaderError, TXXX

def update_tags(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            if file.lower().endswith('.mp3'):
                update_mp3_tags(file_path)
            # elif file.lower().endswith('.flac'):
            #     update_flac_tags(file_path)

def update_mp3_tags(file_path):
    try:
        audio = ID3(file_path)
        if 'TSOP' in audio:
            # audio['ALBUMARTISTSORT'] = audio['TSOP']
            audio['TXXX:ALBUMARTISTSORT'] = TXXX(encoding=3, desc='ALBUMARTISTSORT', text=', '.join(audio['TSOP'])) # with mp3tag, it is USLT with Unix(LF)
            del audio['TSOP']
            audio.save(file_path, v2_version=4)  # Save as ID3v2.4
            print(f"Updated MP3 tags for {file_path}")
    except ID3NoHeaderError:
        print(f"No ID3 header found in {file_path}, skipping.")

def update_flac_tags(file_path):
    audio = FLAC(file_path)
    if 'artistsort' in audio:
        audio['albumartistsort'] = audio['artistsort']
        del audio['artistsort']
        audio.save()
        print(f"Updated FLAC tags for {file_path}")

if __name__ == "__main__":
    update_tags("C:\\Users\\ext.dozen\\Music\\tc-tagged")
