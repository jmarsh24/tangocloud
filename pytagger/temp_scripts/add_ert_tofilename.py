import os
import re

def rename_files_in_directory(directory):
    # Walk through the directory
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.mp3') or file.endswith('.flac'):
                old_file_path = os.path.join(root, file)

                # Use regex to find the part to rename
                new_file_name = re.sub(r'__(\d+)\.', r'__ert_\1.', file)

                if new_file_name != file:
                    new_file_path = os.path.join(root, new_file_name)
                    # Rename the file
                    os.rename(old_file_path, new_file_path)
                    print(f'Renamed: {old_file_path} to {new_file_path}')

# Example usage
directory = '''xxx'''
rename_files_in_directory(directory)
