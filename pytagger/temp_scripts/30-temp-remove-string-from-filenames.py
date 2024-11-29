import os

def remove_text_from_filenames(directory, target_text):
    """
    Traverse the directory tree and remove the specified text from all file names.
    
    Args:
        directory (str): Path to the root directory to traverse.
        target_text (str): The text to remove from file names.
    """
    for root, _, files in os.walk(directory):
        for file_name in files:
            if target_text in file_name:
                old_path = os.path.join(root, file_name)
                new_file_name = file_name.replace(target_text, "")
                new_path = os.path.join(root, new_file_name)
                
                try:
                    os.rename(old_path, new_path)
                    print(f"Renamed: {old_path} -> {new_path}")
                except OSError as e:
                    print(f"Error renaming {old_path}: {e}")

if __name__ == "__main__":
    # Specify the directory and text to remove
    directory_path = 'C:\\Users\\dogac\\Music\\xxNEW_MUSIC\\Color Tango\\Color Tango'
    text_to_remove = '_(roberto_alvarez)'
    
    if os.path.isdir(directory_path):
        remove_text_from_filenames(directory_path, text_to_remove)
    else:
        print("Invalid directory path.")
