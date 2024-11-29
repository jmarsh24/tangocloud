import os
import sqlite3
import PySimpleGUI as sg
from mutagen.mp3 import MP3
from mutagen.id3 import (
    TIT2, TPE1, TPE2, TXXX, TALB, TCOM, TCON, TPUB, USLT, GRP1, TYER, TDRC, TRCK
)
from mutagen.flac import FLAC
from unidecode import unidecode


directory = r"C:\\Users\\dogac\\Music\\xxNEW_MUSIC\\Orquesta Típica Fervor de Buenos Aires - Quién sos (2006)"

ORCHESTRA_LIST = ["Típica Fervor de Buenos Aires"]

def tag_mp3(file_path, header_data, row_data, tangocloudId):
    """Tag an MP3 file using mutagen."""
    mp3 = MP3(file_path)
    mp3.delete()  # Clear existing tags

    # Header tags
    mp3["TALB"] = TALB(encoding=3, text=header_data["album"])
    mp3["TPE2"] = TPE2(encoding=3, text=header_data["album_artist"])
    mp3["TXXX:ALBUMARTISTSORT"] = TXXX(encoding=3, desc="ALBUMARTISTSORT", text=header_data["album_artist_sort"])
    mp3["TPUB"] = TPUB(encoding=3, text=header_data["label"])
    mp3["GRP1"] = GRP1(encoding=3, text=header_data["grouping"])

    # Row-specific tags
    title = row_data["title"]
    artist = row_data["artist"]
    composer = row_data["composer"]
    author = row_data["author"]
    date = row_data.get("date", header_data["date"])  # Use row-specific date if available
    
    mp3["TIT2"] = TIT2(encoding=3, text=title)
    mp3["TPE1"] = TPE1(encoding=3, text=artist)
    mp3["TCOM"] = TCOM(encoding=3, text=composer)
    mp3["TEXT"] = TPE1(encoding=3, text=author)  # Assuming 'author' is lyricist
    mp3["TDRC"] = TDRC(encoding=3, text=date)

    if artist != 'Instrumental':
        mp3['USLT'] = USLT(encoding=3, text=row_data["lyrics"])
        mp3['TXXX:UNSYNCEDLYRICS'] = TXXX(encoding=3, desc='UNSYNCEDLYRICS', text=row_data["lyrics"]) 

    mp3['TCON'] = TCON(encoding=3, text=row_data["style"].title())
    mp3['TXXX:CatalogNumber'] = TXXX(encoding=3, desc='CatalogNumber', text=tangocloudId)

    mmp3['TRCK'] = TRCK(encoding=3, text=row_data["trackno"])

    # Save tags
    mp3.save(v2_version=4)


def tag_flac(file_path, header_data, row_data, tangocloudId):
    """Tag a FLAC file using mutagen."""
    flac = FLAC(file_path)
    flac.delete()  # Clear existing tags

    # Header tags
    flac["album"] = header_data["album"]
    flac["albumartist"] = header_data["album_artist"]
    flac["albumartistsort"] = header_data["album_artist_sort"]

    if header_data["label"] != "?":
        flac["organization"] = header_data["label"]
    
    flac["grouping"] = header_data["grouping"]
    
    # Row-specific tags
    title = row_data["title"]
    artist = row_data["artist"]
    composer = row_data["composer"]
    author = row_data["author"]
    date = row_data.get("date", header_data["date"])  # Use row-specific date if available

    flac["title"] = title
    flac["artist"] = artist
    flac["composer"] = composer
    flac["lyricist"] = author  # Assuming 'author' is lyricist
    flac["date"] = date

    if artist != 'Instrumental':
        flac["unsyncedlyrics"] = row_data["lyrics"]

    flac['genre']  = row_data["style"].title()
    flac['CatalogNumber'] = tangocloudId

    flac["tracknumber"] = row_data["trackno"]

    # Save tags
    flac.save()

def read_and_increment_id():
    file_path = "last_tc_id"
    try:
        # Read the current ID from the file
        with open(file_path, 'r') as file:
            current_id = file.read().strip()
        
        # Increment the ID by converting to an integer and back to a string
        next_id = str(int(current_id) + 1)

        # Save the updated ID back to the file
        with open(file_path, 'w') as file:
            file.write(next_id)
        
        print(f"Current ID: {current_id}, Next ID: {next_id}")
        return next_id
    except FileNotFoundError:
        print(f"File '{file_path}' not found. Creating a new file with ID '1'.")
        # If the file doesn't exist, initialize it with '1'
        with open(file_path, 'w') as file:
            file.write('1')
        return '1'
    except ValueError:
        print(f"File '{file_path}' contains invalid data. Resetting ID to '1'.")
        # If the file contains invalid data, reset it to '1'
        with open(file_path, 'w') as file:
            file.write('1')
        return '1'

def rename_file(file_path, header_data, row_data, extension, tcid):
    """Rename the file based on the given pattern."""
    date = row_data.get("date", header_data["date"]).replace("-", "")
    album_artist = unidecode(header_data["album_artist"]).lower().replace(" ", "_")
    title = unidecode(row_data["title"]).lower().replace(" ", "_")
    artist = unidecode(row_data["artist"]).lower().replace(" ", "_")
    style = row_data["style"]
    new_filename = f"{date}__{album_artist}__{title}__{artist.lower()}__{style.lower()}__{tcid}_FREE{extension}"
    new_filepath = os.path.join(os.path.dirname(file_path), new_filename)

    os.rename(file_path, new_filepath)
    return new_filepath

def get_file_details(directory):
    files = os.listdir(directory)
    file_details = []
    for index, file in enumerate(files):  # Add an index to generate sequential IDs
        fullpath = os.path.join(directory, file)
        filename, extension = os.path.splitext(file)
        file_details.append({
            "id": index,  # Add a unique integer ID
            "fullpath": fullpath,
            "filename": filename,
            "extension": extension
        })
    return file_details

def get_style_label(style, default="Unknown"):
    """Return the corresponding label for the style or a default value."""
    if 'TANGO' in style.upper():
        return 'Tango'
    elif 'MILONGA' in style.upper():
        return 'Milonga'
    elif 'VALS' in style.upper():
        return 'Vals'
    return default

def get_file_detail_by_id(file_details, row_id, lyrics, style, title):
    for file in file_details:
        if int(file["id"]) == int(row_id):
            file["lyrics"] = lyrics
            file["style"] = get_style_label(style)
            file["title"] = title
            return file
    return None

def create_dynamic_rows(file_details, font_size):
    rows = []
    for index, file in enumerate(file_details):
        rows.append([
            sg.InputText(f"{file['id'] + 1:02}", size=(5, 1), font=("Helvetica", font_size), key=f"-NO-{index}"),
            sg.InputText(file["filename"], size=(40, 1), font=("Helvetica", font_size), key=f"-TITLE-{index}"), # Large textbox
            sg.InputText('', size=(10, 1), font=("Helvetica", font_size), key=f"-DATE-{index}"), # Date textbox
            sg.InputText('', size=(15, 1), font=("Helvetica", font_size), key=f"-SINGER-{index}"), # Singer textbox
            sg.Button('Find Like', size=(10, 1), font=("Helvetica", font_size), key=f"-SEARCH-{index}"), # Search button
            sg.InputText('', size=(20, 1), font=("Helvetica", font_size), key=f"-COMPOSER-{index}"),  # Composer label
            sg.InputText('', size=(20, 1), font=("Helvetica", font_size), key=f"-AUTHOR-{index}"), # Author label
            sg.InputText('', size=(10, 1), font=("Helvetica", font_size), key=f"-GENRE-{index}") # Genre textbox            
        ])
    return rows

def search_database_like(title):
    db_path = "tangotagger_v1.db"
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        query = """SELECT composer, author, style, lyrics, title FROM tango_results WHERE (composer <> 'None' OR author <> 'None') AND title LIKE ?"""
        cursor.execute(query, (f"%{title.lower()}%",))
        result = cursor.fetchone()
        conn.close()

        if result:
            composer, author, lyrics, style, title = result + ("",) * (4 - len(result))
            return composer, author, lyrics, style, title.capitalize()
        else:
            return "", "", "", "", ""
    except sqlite3.Error as e:
        return f"Database error: {e}", "Error"

def search_database(title):
    db_path = "tangotagger_v1.db"
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        query = """SELECT composer, author, style, lyrics, title FROM tango_results WHERE (composer <> 'None' OR author <> 'None') AND title = ?"""
        cursor.execute(query, (title.lower(),))
        result = cursor.fetchone()
        conn.close()

        if result:
            composer, author, lyrics, style, title = result + ("",) * (4 - len(result))
            return composer, author, lyrics, style, title.capitalize()
        else:
            return "", "", "", "", ""
    except sqlite3.Error as e:
        return f"Database error: {e}", "Error"

# Validate the directory
if not os.path.isdir(directory):
    sg.popup_error(f"Invalid directory: {directory}")
    exit()

# Get file details
file_details = get_file_details(directory)

# Set custom theme for darker background
sg.theme_background_color('#2E2E2E')  # Darker background
sg.theme_text_color('#FFFFFF')  # Whitish text color
sg.theme_input_background_color('#3E3E3E')  # Slightly lighter for input boxes
sg.theme_input_text_color('#FFFFFF')  # Whitish text in input boxes
sg.theme_button_color(('#FFFFFF', '#3E3E3E'))  # White text with dark background for buttons
font_size = 16

# Create rows dynamically based on file details
rows_layout = create_dynamic_rows(file_details, font_size)

top_section = [
    [sg.Text('Selected Directory:', font=("Helvetica", font_size)), 
     sg.Text(directory, font=("Helvetica", font_size))],
    [sg.Text('Album:', size=(15, 1), font=("Helvetica", font_size)), sg.InputText(os.path.basename(directory), size=(50, 1), key="-ALBUM-")],
    [sg.Text('AlbumArtistSort:', size=(15, 1), font=("Helvetica", font_size)), sg.InputText('', size=(50, 1), key="-ALBUMARTISTSORT-")],
    [sg.Text('Orchestra:', size=(15, 1), font=("Helvetica", font_size)), sg.Combo(ORCHESTRA_LIST, size=(48, 1), key="-ORCHESTRA-", readonly=True)],
    [sg.Text('Label:', size=(15, 1), font=("Helvetica", font_size)), sg.InputText('?', size=(50, 1), key="-LABEL-")],
    [sg.Text('Grouping:', size=(15, 1), font=("Helvetica", font_size)), sg.InputText('FREE', size=(50, 1), key="-GROUPING-")],
    [sg.Text('Date:', size=(15, 1), font=("Helvetica", font_size)), sg.InputText('', size=(50, 1), key="-DATE-")],
]

# Add headers for the columns
headers = [
    [sg.Text('No', size=(5, 1), font=("Helvetica", font_size)),
     sg.Text('Title', size=(40, 1), font=("Helvetica", font_size)),
     sg.Text('Date', size=(10, 1), font=("Helvetica", font_size)),
     sg.Text('Singer', size=(15, 1), font=("Helvetica", font_size)),
     sg.Button('Find All', size=(10, 1), font=("Helvetica", font_size), key="-FIND-ALL-"),
     sg.Text('Composer', size=(20, 1), font=("Helvetica", font_size)),
     sg.Text('Author', size=(20, 1), font=("Helvetica", font_size)),
     sg.Text('Genre', size=(10, 1), font=("Helvetica", font_size))],
]

# Add bottom buttons
bottom_section = [
    [sg.Button('Delete First Char', size=(20, 1), font=("Helvetica", font_size), key="-DELETE-FIRST-"),
     sg.Button('Delete Last Char', size=(20, 1), font=("Helvetica", font_size), key="-DELETE-LAST-"),
     sg.Button('Replace in Titles', size=(20, 1), font=("Helvetica", font_size), key="-REPLACE-TITLES-"), 
     sg.InputText('', size=(20, 1), font=("Helvetica", font_size), key="-REPLACE-TEXT-")],
     [sg.Button('Tag and Rename', size=(20, 1), font=("Helvetica", font_size), key="-TAG-RENAME-")]
]

# Combine the top section, headers, dynamic rows, and bottom buttons
layout = top_section + headers + rows_layout + bottom_section

# Create the main window
window = sg.Window('Dynamic Rows Example', layout, finalize=True)
window.maximize()

# Main event loop
while True:
    event, values = window.read()
    if event in (sg.WINDOW_CLOSED, 'Exit'):
        break
    elif event == "-FIND-ALL-":
        for index, file in enumerate(file_details):
            title = values.get(f"-TITLE-{index}", "").strip()
            if title:
                composer, author, style, lyrics, title  = search_database(title)

                window[f"-COMPOSER-{index}"].update("" if composer is None else composer)
                window[f"-AUTHOR-{index}"].update("" if author is None else author)
                window[f"-GENRE-{index}"].update("" if style is None else style)

                get_file_detail_by_id(file_details, index, lyrics, style, title)
            else:
                sg.popup_error(f"Row {index + 1}: Title is empty. Please provide a title.")
    elif event.startswith("-SEARCH-"):
        row_index = event.replace("-SEARCH-", "")
        title = values.get(f"-TITLE-{row_index}", "").strip()
        if title:
            composer, author, style, lyrics, title = search_database_like(title)

            if not title:
                title = window[f"-TITLE-{index}"].get().strip()
                style = window[f"-GENRE-{index}"].get().strip()
                lyrics = "TODO: TO BE DEFINED MANUALLY"

            window[f"-COMPOSER-{row_index}"].update("" if composer is None else composer)
            window[f"-AUTHOR-{row_index}"].update("" if author is None else author)
            window[f"-GENRE-{index}"].update("" if style is None else style)

            get_file_detail_by_id(file_details, row_index, lyrics, style, title)
        else:
            sg.popup_error("First textbox is empty. Please provide a title.")
    elif event == "-DELETE-FIRST-":
        for index in range(len(file_details)):
            title = values.get(f"-TITLE-{index}", "")
            if title:
                new_title = title[1:]  # Remove the first character
                window[f"-TITLE-{index}"].update(new_title)
    elif event == "-DELETE-LAST-":
        for index in range(len(file_details)):
            title = values.get(f"-TITLE-{index}", "")
            if title:
                new_title = title[:-1]  # Remove the last character
                window[f"-TITLE-{index}"].update(new_title)
    elif event == "-REPLACE-TITLES-":
        replace_text = values.get("-REPLACE-TEXT-", "").strip()
        if replace_text:
            for index in range(len(file_details)):
                title = values.get(f"-TITLE-{index}", "")
                if title:
                    new_title = title.replace(replace_text, " ")  # Replace occurrences
                    window[f"-TITLE-{index}"].update(new_title)
    elif event == "-TAG-RENAME-":
        header_data = {
            "album": values["-ALBUM-"].strip(),
            "album_artist": values["-ORCHESTRA-"].strip(),
            "album_artist_sort": values["-ALBUMARTISTSORT-"].strip(),
            "label": values["-LABEL-"].strip(),
            "grouping": values["-GROUPING-"].strip(),
            "date": values["-DATE-"].strip()
        }

        for index, file in enumerate(file_details):
            tangocloudId = "TC"+read_and_increment_id()            
            row_data = {
                "fullpath": file["fullpath"],
                "extension": file["extension"],
                "title": file["title"].strip(),
                "artist": values.get(f"-SINGER-{index}", "").strip() or "Instrumental",
                "composer": window[f"-COMPOSER-{index}"].get().strip(),
                "author": window[f"-AUTHOR-{index}"].get().strip(),
                "date": values.get(f"-DATE-{index}", "").strip() or header_data["date"],
                "lyrics": file.get("lyrics", ""),
                "style": window[f"-GENRE-{index}"].get().strip(),
                "trackno": window[f"-NO-{index}"].get().strip(),
            }

            if not row_data["title"]:
                sg.popup_error(f"Row {index + 1}: Title is empty. Skipping...")
                continue

            if row_data["extension"].lower() == ".mp3":
                try:
                    tag_mp3(row_data["fullpath"], header_data, row_data, tangocloudId)
                except Exception as e:
                    sg.popup_error(f"Error tagging MP3 file: {file['filename']}\n{e}")
            elif row_data["extension"].lower() == ".flac":
                try:
                    tag_flac(row_data["fullpath"], header_data, row_data, tangocloudId)
                except Exception as e:
                    sg.popup_error(f"Error tagging FLAC file: {file['filename']}\n{e}")
            else:
                sg.popup_error(f"Unsupported file format: {file['filename']}")
                continue

            try:
                new_filepath = rename_file(row_data["fullpath"], header_data, row_data, row_data["extension"], tangocloudId)
                # sg.popup(f"File processed and renamed:\n{new_filepath}")
            except Exception as e:
                sg.popup_error(f"Error renaming file: {file['filename']}\n{e}")

window.close()