import os

def rename_music_files(root_folder):
    for root, dirs, files in os.walk(root_folder):
        for file_name in files:
            # Check if the file is an mp3 or flac file
            if file_name.endswith('.mp3') or file_name.endswith('.flac'):
                # Remove 'dir._' from the file name
                new_file_name = file_name.replace('dir._', '')
                if new_file_name != file_name:
                    # Construct full file paths
                    old_file_path = os.path.join(root, file_name)
                    new_file_path = os.path.join(root, new_file_name)
                    
                    # Rename the file
                    os.rename(old_file_path, new_file_path)
                    print(f'Renamed: {old_file_path} -> {new_file_path}')

# Example usage
root_folder = 'C:\\Users\\ext.dozen\\Music\\TT-TTT-tagged'
rename_music_files(root_folder)