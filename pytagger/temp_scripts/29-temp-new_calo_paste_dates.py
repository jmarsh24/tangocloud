import os
import re

# Define the directories
# old_files_dir = 'C:\\Users\\dogac\\Music\\Caló, Miguel'
# new_files_dir = 'C:\\Users\\dogac\\Music\\xxNEW\\CALO'

# Function to extract the TC ID from a filename
def extract_tc_id(filename):
    match = re.search(r'TC\d+', filename)
    return match.group(0) if match else None

# Function to extract the date from the old filename
def extract_date(filename):
    match = re.match(r'(\d{8}__)', filename)
    return match.group(1) if match else None

# Get a mapping of TC ID to date from old_files
tc_date_mapping = {}
for old_file in os.listdir(old_files_dir):
    old_file_path = os.path.join(old_files_dir, old_file)
    if os.path.isfile(old_file_path):
        tc_id = extract_tc_id(old_file)
        date_part = extract_date(old_file)
        if tc_id and date_part:
            tc_date_mapping[tc_id] = date_part

# Process files in new_files and rename them
for new_file in os.listdir(new_files_dir):
    new_file_path = os.path.join(new_files_dir, new_file)
    if os.path.isfile(new_file_path):
        tc_id = extract_tc_id(new_file)
        if tc_id and tc_id in tc_date_mapping:
            date_part = tc_date_mapping[tc_id]
            new_filename = f"{date_part}{new_file}"
            new_file_renamed_path = os.path.join(new_files_dir, new_filename)
            os.rename(new_file_path, new_file_renamed_path)
            print(f"Renamed: {new_file} -> {new_filename}")

print("Renaming completed.")
