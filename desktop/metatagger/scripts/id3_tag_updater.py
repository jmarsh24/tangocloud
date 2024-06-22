import os
import shutil
from mutagen.id3 import ID3, TIT2, TALB, TPE1, TPE2, TBPM, TCOM, TCON, TLEN, TPUB, TSOP, TXXX, TYER, TDRC, TDAT, TDOR, ID3NoHeaderError

class ID3TagUpdater:
    def __init__(self, input_folder_path, output_folder_path, tags):
        self.input_folder_path = input_folder_path
        self.output_folder_path = output_folder_path
        self.tags = tags

    def copy_and_tag_all(self):
        # Ensure the output directory exists
        os.makedirs(self.output_folder_path, exist_ok=True)

        # Iterate over all files in the input directory
        for file_name in os.listdir(self.input_folder_path):
            input_file_path = os.path.join(self.input_folder_path, file_name)
            output_file_path = os.path.join(self.output_folder_path, f"{os.path.splitext(file_name)[0]}_tagged.mp3")
            self.copy_and_tag(input_file_path, output_file_path)

    def copy_and_tag(self, input_file_path, output_file_path):
        print(f"Copying file from {input_file_path} to {output_file_path}")
        # Copy the file to the output directory
        shutil.copy(input_file_path, output_file_path)

        try:
            audio = ID3(output_file_path)
        except ID3NoHeaderError:
            audio = ID3()

        # Update tags
        audio['TIT2'] = TIT2(encoding=3, text=self.tags.get('title', ''))
        audio['TALB'] = TALB(encoding=3, text=self.tags.get('album', ''))
        audio['TPE1'] = TPE1(encoding=3, text=self.tags.get('artist', ''))
        audio['TPE2'] = TPE2(encoding=3, text=self.tags.get('album_artist', ''))
        audio['TBPM'] = TBPM(encoding=3, text=self.tags.get('TBPM', ''))
        audio['TCOM'] = TCOM(encoding=3, text=self.tags.get('composer', ''))
        audio['TCON'] = TCON(encoding=3, text=self.tags.get('genre', ''))
        audio['TLEN'] = TLEN(encoding=3, text=self.tags.get('TLEN', ''))
        audio['TPUB'] = TPUB(encoding=3, text=self.tags.get('publisher', ''))
        audio['TSOP'] = TSOP(encoding=3, text=self.tags.get('artist_sort', ''))
        audio['TXXX:BARCODE'] = TXXX(encoding=3, desc='BARCODE', text=self.tags.get('BARCODE', ''))
        audio['TXXX:ORGANIZATION'] = TXXX(encoding=3, desc='ORGANIZATION', text=self.tags.get('ORGANIZATION', ''))

        # Add year, date, and original release date for compatibility
        if 'TYER' in self.tags:
            audio['TYER'] = TYER(encoding=3, text=self.tags['TYER'])
        if 'TDAT' in self.tags:
            audio['TDAT'] = TDAT(encoding=3, text=self.tags['TDAT'])
        if 'TDOR' in self.tags:
            audio['TDRC'] = TDRC(encoding=3, text=self.tags['TDOR'])
            audio['TDOR'] = TDOR(encoding=3, text=self.tags['TDOR'])

        # Save changes using ID3v2.4
        audio.save(output_file_path, v2_version=4)
        print(f"Tags updated and saved to {output_file_path}")

        # Debug print
        for frame in audio.keys():
            print(f"{frame}: {audio[frame]}")

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 3:
        print("Usage: python3 id3_tag_updater.py <input_folder_path> <output_folder_path>")
        sys.exit(1)

    input_folder_path = sys.argv[1]
    output_folder_path = sys.argv[2]

    tags = {
        'title': 'Jorge Duval',
        'album': 'De Angelis - Su Obra Completa',
        'artist': 'Instrumental',
        'album_artist': 'Alfredo De Angelis',
        'TBPM': '122.60',
        'composer': 'Alfredo De Angelis',
        'genre': 'TANGO',
        'TLEN': '173040',
        'publisher': '',
        'TYER': '1950',
        'artist_sort': 'De Angelis',
        'replaygain_track_gain': '-3.33 dB',
        'replaygain_track_peak': '0.979065',
        'BARCODE': 'ERT-13735',
        'ORGANIZATION': '',
        'TDAT': '0419',
        'TDOR': '1950-04-19'
    }

    updater = ID3TagUpdater(input_folder_path, output_folder_path, tags)
    updater.copy_and_tag_all()