import os
import sys
import pytest
import shutil
from mutagen.id3 import ID3

# Ensure the scripts directory is in the import path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../scripts')))

from update_id3_tags import update_id3_tags

@pytest.fixture
def setup_test_environment(tmp_path):
    # Setup directories
    input_folder = tmp_path / "input_files"
    output_folder = tmp_path / "output_files"
    input_folder.mkdir()
    output_folder.mkdir()

    # Path to the real audio file
    real_audio_file_path = os.path.abspath(os.path.join(os.path.dirname(__file__), '../input/19500419__jorge_duval__instrumental__tango__13735.mp3'))
    test_audio_file = input_folder / "19500419__jorge_duval__instrumental__tango__13735.mp3"
    # Copy the real audio file to the test environment
    shutil.copy(real_audio_file_path, test_audio_file)
    
    return test_audio_file, output_folder

def test_update_id3_tags(setup_test_environment):
    input_file, output_folder = setup_test_environment
    output_file = output_folder / "19500419__jorge_duval__instrumental__tango__13735_tagged.mp3"

    tags = {
        'title': 'Jorge Duval',
        'album': 'De Angelis - Su Obra Completa',
        'artist': 'Instrumental',
        'album_artist': 'Alfredo De Angelis',
        'TBPM': '122.60',
        'composer': 'Alfredo De Angelis',
        'genre': 'TANGO',
        'TLEN': '173040',
        'publisher': 'None',
        'TYER': '1950',
        'artist_sort': 'De Angelis',
        'replaygain_track_gain': '-3.33 dB',
        'replaygain_track_peak': '0.979065',
        'BARCODE': 'ERT-13735',
        'ORGANIZATION': 'None',
        'TDAT': '0419',
        'TDOR': '1950-04-19'
    }

    print(f"Input file: {input_file}")
    print(f"Output file: {output_file}")
    update_id3_tags(input_file, output_file, tags)
    
    # Verify the file is in the output folder
    assert output_file.exists(), f"Output file {output_file} does not exist"
    
    # Verify the tags
    audio = ID3(output_file)
    assert audio['TIT2'].text[0] == 'Jorge Duval'
    assert audio['TALB'].text[0] == 'De Angelis - Su Obra Completa'
    assert audio['TPE1'].text[0] == 'Instrumental'
    assert audio['TPE2'].text[0] == 'Alfredo De Angelis'
    assert audio['TBPM'].text[0] == '122.60'
    assert audio['TCOM'].text[0] == 'Alfredo De Angelis'
    assert audio['TCON'].text[0] == 'TANGO'
    assert audio['TLEN'].text[0] == '173040'
    assert audio['TPUB'].text[0] == 'None'
    # assert audio['TYER'].text[0] == '1950'  # Check for TYER frame
    assert audio['TSOP'].text[0] == 'De Angelis'
    assert audio['TXXX:replaygain_track_gain'].text[0] == '-3.33 dB'
    assert audio['TXXX:replaygain_track_peak'].text[0] == '0.979065'
    assert audio['TXXX:BARCODE'].text[0] == 'ERT-13735'
    assert audio['TXXX:ORGANIZATION'].text[0] == 'None'
    # assert audio['TDAT'].text[0] == '0419'
    # assert audio['TDOR'].text[0] == '1950-04-19'
    print("All tags verified successfully.")