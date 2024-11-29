import os
import re

def rename_files_in_directory(root_dir):
    # Compile the regex pattern to match the numbers at the end of the file names
    pattern = re.compile(r'__(\d+)(\.mp3|\.flac)$')
    
    # Walk through the directory tree
    for dirpath, _, filenames in os.walk(root_dir):
        for filename in filenames:
            if filename.endswith(('.mp3', '.flac')):
                # Search for the pattern in the filename
                new_filename = pattern.sub(r'\2', filename)
                
                # Rename the file if the pattern is found
                if new_filename != filename:
                    old_filepath = os.path.join(dirpath, filename)
                    new_filepath = os.path.join(dirpath, new_filename)
                    os.rename(old_filepath, new_filepath)
                    print(f'Renamed: {old_filepath} to {new_filepath}')

rename_files_in_directory('C:\\Users\\dogac\\Music\\TTT12')
