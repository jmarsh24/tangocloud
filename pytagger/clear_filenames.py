import os

def rename_audio_files(directory):
    # Iterate over all files in the specified directory
    for filename in os.listdir(directory):
        # Split the filename at the dots
        parts = filename.split('.')
        
        # Check if there are at least three parts (two dots including the one before the file extension)
        if len(parts) > 2:
            # Join the parts excluding the one between the first and second dots
            new_filename = parts[0] + '.' + parts[-1]
            # Add back the extension
            if len(parts) > 3:
                new_filename += '.' + parts[-2]

            # Get the full old and new file paths
            old_filepath = os.path.join(directory, filename)
            new_filepath = os.path.join(directory, new_filename)
            
            # Rename the file
            os.rename(old_filepath, new_filepath)
            print(f'Renamed: {filename} -> {new_filename}')
        else:
            print(f'Skipped: {filename} (does not have two dots including the one before the file extension)')

if __name__ == "__main__":
    # Specify the directory containing the audio files
    d = r'''xxx'''
    
    rename_audio_files(d)
