FOLDER = 'C:\\Users\\ext.dozen\\Music\\xxxProcessing\\Goyeneche'

from databaseconnection import DatabaseConnection
from recording import Recording

from PyQt6.QtWidgets import (
    QApplication, QMainWindow, QSplitter, QWidget, QGridLayout, QLabel, QLineEdit, QStyle, 
    QSpacerItem, QSizePolicy, QPushButton, QVBoxLayout, QTableWidget, QHeaderView, 
    QTableWidgetItem, QHBoxLayout, QTableView, QAbstractItemView, QStyledItemDelegate
)
from PyQt6.QtCore import Qt, QEvent, QModelIndex
from PyQt6.QtGui import QColor, QBrush

from mutagen.mp3 import MP3
from mutagen.flac import FLAC
import os, sys

class CustomDelegate(QStyledItemDelegate):
    def paint(self, painter, option, index):
        if option.state & QStyle.StateFlag.State_Selected:  # Correct
            painter.save()
            painter.fillRect(option.rect, QColor(173, 216, 230))  # Light blue color for selected rows
            painter.restore()
        super().paint(painter, option, index)

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.labels = ['Id', 'Title', 'Orchestra', 'Singer', 'Date', 'Soloist', 'Director', 'Genre', 'Composer', 'Author', 'Count']

        # Set window title and dimensions
        self.setWindowTitle('Audio File Manager')
        self.setGeometry(100, 100, 800, 600)

        # Create the main vertical splitter
        main_splitter = QSplitter(Qt.Orientation.Vertical)

        # Create the upper horizontal splitter
        upper_splitter = QSplitter(Qt.Orientation.Horizontal)

        # Create the left panel
        left_panel = QWidget()
        left_layout = QGridLayout()
        left_panel.setLayout(left_layout)

        # Add labels and textboxes to the left panel
        self.fields = {
            "Title": QLineEdit(),
            "Artist": QLineEdit(),
            "Album Artist": QLineEdit(),
            "Album": QLineEdit(),
            "Genre": QLineEdit(),
            "Composer": QLineEdit(),
            "Lyricist": QLineEdit(),
            "Date": QLineEdit(),
            "Grouping": QLineEdit(),
            "Organization": QLineEdit(),
            "Lyrics": QLineEdit()
        }

        for i, label in enumerate(self.fields):
            qlabel = QLabel(label)
            qlineedit = QLineEdit()
            qlineedit.textChanged.connect(lambda text, label=label: self.update_field(label, text))  # Connect signal to update method
            left_layout.addWidget(qlabel, i, 0, alignment=Qt.AlignmentFlag.AlignTop)
            left_layout.addWidget(qlineedit, i, 1, alignment=Qt.AlignmentFlag.AlignTop)

        # Add a spacer to push the widgets to the top
        spacer = QSpacerItem(20, 40, QSizePolicy.Policy.Minimum, QSizePolicy.Policy.Expanding)
        left_layout.addItem(spacer, len(self.fields), 0, 1, 2)

        btnsave = QPushButton("Save")
        btnsave.clicked.connect(self.save_tags)
        left_layout.addWidget(btnsave)

        # Create the right panel
        right_panel = QWidget()
        right_layout = QVBoxLayout()
        right_panel.setLayout(right_layout)

        # Create the table widget
        self.table_widget = QTableWidget()
        self.table_widget.setColumnCount(4)
        self.table_widget.setHorizontalHeaderLabels(['File Name', 'Title', 'Artist', 'Album'])
        self.table_widget.horizontalHeader().setSectionResizeMode(QHeaderView.ResizeMode.Stretch)

        # Set selection behavior and mode
        self.table_widget.setSelectionBehavior(QTableWidget.SelectionBehavior.SelectRows)
        self.table_widget.setSelectionMode(QTableWidget.SelectionMode.MultiSelection)

        # Set custom delegate
        self.table_widget.setItemDelegate(CustomDelegate())

        # Populate the table with audio files
        self.populate_table(FOLDER)

        # Add the table to the right layout
        right_layout.addWidget(self.table_widget)

        # Add the panels to the upper splitter
        upper_splitter.addWidget(left_panel)
        upper_splitter.addWidget(right_panel)

        # Create the bottom panel for the database table view and search button
        bottom_panel = QWidget()
        bottom_layout = QVBoxLayout()
        bottom_panel.setLayout(bottom_layout)

        # Create a horizontal layout for the search button and search input
        search_layout = QHBoxLayout()
        self.search_input = QLineEdit()
        search_button = QPushButton("Search")
        search_button.clicked.connect(self.populate_db_table)
        search_layout.addWidget(QLabel("Search:"))
        search_layout.addWidget(self.search_input)
        search_layout.addWidget(search_button)
        
        # Create the database table view
        self.db_table_view = QTableWidget()
        self.db_table_view.setSelectionBehavior(QAbstractItemView.SelectionBehavior.SelectRows)
        self.db_table_view.setSelectionMode(QAbstractItemView.SelectionMode.MultiSelection)
        
        self.db_table_view.setColumnCount(len(self.labels))
        self.db_table_view.setHorizontalHeaderLabels(self.labels)

        # Add the search layout and table view to the bottom layout
        bottom_layout.addLayout(search_layout)
        bottom_layout.addWidget(self.db_table_view)

        # Add the upper and bottom panels to the main splitter
        main_splitter.addWidget(upper_splitter)
        main_splitter.addWidget(bottom_panel)
        
        # Set the main splitter as the central widget
        self.setCentralWidget(main_splitter)

        # Install event filter
        self.table_widget.installEventFilter(self)

        self.populate_db_table()
        
    def update_field(self, field_name, text):
        self.fields[field_name].setText(text)  

    def save_tags(self):
        print("Saving tags...")
        tags = {}
        for field_name, widget in self.fields.items():
            if isinstance(widget, QLineEdit):
                tags[field_name] = widget.text()
        print("Tags collected:", tags)

        selected_items = self.table_widget.selectedItems()
        selected_rows = set(item.row() for item in selected_items)  # Collect unique row numbers
        # print(f"Selected Rows: {sorted(selected_rows)}")  # Print sorted list of selected rows

        # Print the first column value for all the selected rows
        for row in selected_rows:
            item = self.table_widget.item(row, 0)  # Access the item in the first column of this row
            if item:  # Check if the item exists
                print(f"Row {row} First Column Value: {item.text()}")



    def populate_table(self, folder_path):
        audio_files = [f for f in os.listdir(folder_path) if f.endswith('.mp3') or f.endswith('.flac')]
        self.table_widget.setRowCount(len(audio_files))
        
        for row, file_name in enumerate(audio_files):
            file_path = os.path.join(folder_path, file_name)
            if file_name.endswith('.mp3'):
                audio = MP3(file_path)
            elif file_name.endswith('.flac'):
                audio = FLAC(file_path)
            else:
                continue
            
            title = audio.get('TIT2', 'Unknown') if isinstance(audio, MP3) else audio.get('title', ['Unknown'])[0]
            artist = audio.get('TPE1', 'Unknown') if isinstance(audio, MP3) else audio.get('artist', ['Unknown'])[0]
            album = audio.get('TALB', 'Unknown') if isinstance(audio, MP3) else audio.get('album', ['Unknown'])[0]
            
            self.table_widget.setItem(row, 0, QTableWidgetItem(file_name))
            self.table_widget.setItem(row, 1, QTableWidgetItem(title))
            self.table_widget.setItem(row, 2, QTableWidgetItem(artist))
            self.table_widget.setItem(row, 3, QTableWidgetItem(album))

    def select_all_rows(self):
        self.table_widget.selectAll()

    def eventFilter(self, source, event):
        if event.type() == QEvent.Type.KeyPress:
            if event.key() == Qt.Key.Key_A and QApplication.keyboardModifiers() == Qt.KeyboardModifier.ShiftModifier:
                self.select_all_rows()
                return True
        if event.type() == QEvent.Type.MouseButtonPress:
            if source is self.table_widget:
                clicked_index = self.table_widget.indexAt(event.pos())
                if clicked_index.isValid():
                    # Ensure this logic runs only if the table widget is the source of the event
                    self.clear_and_select_row(clicked_index.row())
                    return True
        return super().eventFilter(source, event)

    def clear_and_select_row(self, row):
        # Clear all selections first
        self.table_widget.clearSelection()
        # Then select the row that was clicked
        self.table_widget.selectRow(row)

    def search_database(self):
        # Perform a search on the database and update the db_table_view
        pass

    def populate_db_table(self):
        conn = DatabaseConnection().get_connection()
        cursor = conn.cursor()
        query = f'''
        SELECT music_id, title, orchestra, singers, date, soloist, director,
        CASE 
            WHEN style = 'TANGO' THEN 'T'
            WHEN style = 'MILONGA' THEN 'M'
            WHEN style = 'VALS' THEN 'V'
            ELSE style END, 
        composer, author,
        CASE WHEN duplicate_count IS NULL THEN '' ELSE duplicate_count END
        FROM recordings
        WHERE is_mapped = 0 AND title LIKE '%{self.search_input.text()}%' OR orchestra LIKE '%{self.search_input.text()}%'
        '''
        cursor.execute(query)
        records = cursor.fetchall()
        
        self.db_table_view.setRowCount(len(records))
        for row_index, record in enumerate(records):
            for column_index, data in enumerate(record):
                table_item = QTableWidgetItem(str(data))
                self.db_table_view.setItem(row_index, column_index, table_item)

if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())
