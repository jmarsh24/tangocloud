import os
from mutagen.flac import FLAC
from mutagen.mp3 import MP3
from mutagen.id3 import ID3, GRID, GRP1, TXXX

# def update_grouping(file_path, album_name):
#     if 'Su Obra Completa' in album_name:
#         grouping = 'Free'
#     elif 'Tango Time Travel' in album_name:
#         grouping = 'Tango Time Travel'
#     elif 'TTT' in album_name:
#         grouping = 'Tango Time Travel'
#     elif 'TT' in album_name:
#         grouping = 'Tango Tunes'
#     else:
#         grouping = 'Free'
#     return grouping

# def process_flac(file_path):
#     audio = FLAC(file_path)
#     if 'GROUPING' in audio:
#         album_name = audio['GROUPING'][0]
#         grouping = update_grouping(file_path, album_name)
#         if grouping:
#             audio['grouping'] = grouping
#             audio.save()
            # # print(f"Updated grouping for FLAC file: {file_path}")

def process_mp3(file_path):
    audio = MP3(file_path, ID3=ID3)
    if 'GRP1' in audio:
        album_name = audio['GRP1'].text[0]
        # audio['GRID'] = GRID(encoding=3, text=album_name)
        # audio['GRP1'] = GRP1(encoding=3, text=grouping)
        audio['TXXX:grouping'] = TXXX(encoding=3, desc='grouping', text=album_name)
        
        audio.save(file_path, v2_version=4)

        print(f"GRP1 for MP3 file: {audio['GRP1'].text[0]}")

def process_directory(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            # if file.lower().endswith('.flac'):
            #     process_flac(file_path)
            # el
            if file.lower().endswith('.mp3'):
                process_mp3(file_path)

if __name__ == "__main__":
    process_directory("C:\\Users\\ext.dozen\\Music\\tc_tagged_library")
