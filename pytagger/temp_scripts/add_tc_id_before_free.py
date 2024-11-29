import os
import re

def rename_files_with_tc_id(directory_path, starting_id=8239):
    current_id = starting_id
    
    try:
        # Sort files alphabetically to ensure a consistent renaming order
        files = sorted(f for f in os.listdir(directory_path) if os.path.isfile(os.path.join(directory_path, f)))

        pattern = re.compile(r'__(\d+)__FREE')

        for filename in files:
            match = pattern.search(filename)
            if match:

                new_id = f"TC{current_id:04d}"
                new_filename = pattern.sub(f"__{new_id}__FREE", filename)
                
                # Rename the file
                old_full_path = os.path.join(directory_path, filename)
                new_full_path = os.path.join(directory_path, new_filename)
                os.rename(old_full_path, new_full_path)
                
                print(f"Renamed: {filename} -> {new_filename}")
                
                current_id += 1

        print("All files have been renamed successfully.")
    
    except Exception as e:
        print(f"An error occurred: {e}")

# Specify the path to your directory
directory_path = "C:\\Users\\dogac\\Music\\xxx_CANARO_Rafael"
rename_files_with_tc_id(directory_path)
