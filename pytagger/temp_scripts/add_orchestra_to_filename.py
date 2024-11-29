import os

def rename_files(directory):
    for filename in os.listdir(directory):
        # Ensure the file is not a hidden file (e.g., .DS_Store on macOS)
        if filename.startswith('.'):
            continue
        
        # Split the filename by "__"
        parts = filename.split('__')

        # Check if the file name contains at least 5 parts
        if len(parts) >= 5:
            # Insert 'rodolfo_biagi' between the release date (parts[0]) and the song name (parts[1])
            new_filename = f"{parts[0]}__rodolfo_biagi__{parts[1]}__{parts[2]}__{parts[3]}__{parts[4]}"

            # Get the full paths
            old_file = os.path.join(directory, filename)
            new_file = os.path.join(directory, new_filename)

            # Output the old and new filenames for debugging purposes
            print(f"Renaming: {old_file} -> {new_file}")

            try:
                # Rename the file
                os.rename(old_file, new_file)
                print(f"Successfully renamed: {filename} -> {new_filename}")
            except Exception as e:
                print(f"Failed to rename {filename}: {e}")
        else:
            print(f"Filename {filename} does not match the expected pattern.")

rename_files('C:\\Users\\dogac\\Music\\TTT12')