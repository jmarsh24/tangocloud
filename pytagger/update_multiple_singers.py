import os

from mutagen.id3 import ID3, TPE1, ID3NoHeaderError
from mutagen.flac import FLAC

def update_artist_tag(file_path):
    try:
        if file_path.endswith('.mp3'):
            try:
                audio = ID3(file_path)
            except ID3NoHeaderError:
                audio = ID3()
                audio.save(file_path, v2_version=4)

            if 'TPE1' in audio:
                artist_list = audio.getall('TPE1')[0].text
                if len(artist_list) > 1:
                    new_artist = ', '.join(aa for aa in artist_list)
                    audio.delall('TPE1')
                    audio.add(TPE1(encoding=3, text=new_artist))
                    audio.save(file_path, v2_version=4)
                    print(f"Updated artist tag for {file_path}")

        elif file_path.endswith('.flac'):
            audio = FLAC(file_path)
            if 'artist' in audio:
                artists = audio['artist']
                if isinstance(artists, list) and len(artists) > 1:
                    # Join artist names with a comma
                    new_artist = ', '.join(artists)
                    audio['artist'] = new_artist
                    audio.save()
                    print(f"Updated artist tag for {file_path}")

    except Exception as e:
        print(f"Error processing {file_path}: {e}")

def process_folder(root_folder):
    for root, dirs, files in os.walk(root_folder):
        for file_name in files:
            if file_name.endswith('.mp3') or file_name.endswith('.flac'):
                file_path = os.path.join(root, file_name)
                update_artist_tag(file_path)

# Example usage
root_folder = 'C:\\Users\\ext.dozen\\Music\\TT-TTT-tagged'
process_folder(root_folder)
