import os

def add_suffix_to_files(directory_path, suffix="__FREE"):
    try:
        # Iterate through all items in the specified directory
        for filename in os.listdir(directory_path):
            # Create the full path of the file
            full_path = os.path.join(directory_path, filename)
            
            # Check if it's a file (not a directory)
            if os.path.isfile(full_path):
                # Split the file name and extension
                name, ext = os.path.splitext(filename)
                # Create the new name by adding the suffix before the extension
                new_filename = f"{name}{suffix}{ext}"
                new_full_path = os.path.join(directory_path, new_filename)
                
                # Rename the file
                os.rename(full_path, new_full_path)
                print(f"Renamed: {filename} -> {new_filename}")
        print("All files have been renamed successfully.")
    
    except Exception as e:
        print(f"An error occurred: {e}")

# Specify the path to your directory
directory_path = "C:\\Users\\dogac\\Music\\xxx CANARO Rafael"
add_suffix_to_files(directory_path)
