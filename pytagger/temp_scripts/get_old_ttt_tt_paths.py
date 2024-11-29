import sqlite3

def process_relative_file_path(file_path):
    first_element = file_path.split('|')[0]
    processed_path = first_element.replace('_DONE_', '')
    return processed_path

def get_paths_from_database(db_path):
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    query = """
    SELECT relative_file_path 
    FROM recordings 
    WHERE is_mapped = TRUE AND audio_source IN ('TTT', 'TT');
    """
    cursor.execute(query)    
    results = cursor.fetchall()
    paths = [process_relative_file_path(row[0]) for row in results]
    conn.close()
    return paths

db_path = 'tango_manager_v2_from_golang.db'
paths = get_paths_from_database(db_path)

# Print the processed paths
for path in paths:
    print(path)
