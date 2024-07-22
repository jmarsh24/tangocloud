from PyQt6.QtWidgets import QApplication, QMainWindow, QCheckBox, QPushButton, QWidget, QSplitter, QLabel, QListWidget, QListWidgetItem, QHBoxLayout, QLineEdit, QTableWidget, QTableWidgetItem, QHeaderView, QAbstractItemView, QStyledItemDelegate, QRadioButton, QButtonGroup, QScrollArea, QFrame, QVBoxLayout, QSizePolicy
from PyQt6.QtCore import Qt
from PyQt6.QtGui import QIntValidator

from unidecode import unidecode
from enum import Enum
from datetime import datetime

import re
import time
import pyuca
import sys
import os
import json

from mutagen.mp3 import MP3
from mutagen.flac import FLAC
from mutagen.id3 import ID3, GRID, TEXT, USLT, TIT2, TALB, TPE1, TPE2, TCOM, TCON, TPUB, TSOP, TXXX, TYER, TDRC, TDOR, ID3NoHeaderError, GRP1, APIC

# from mainV2 import *
from recording import Recording
from databaseconnection import DatabaseConnection

DATE_ZERO_TIME = '-01-01 00:00:00+00:00'
DEFAULT_PATH = "C:/Users/ext.dozen/Music/TT-TTT-tagged"
DATABASE_JSON_FILENAME = 'el_recodo_db.json'

COLOR_MATCH = Qt.GlobalColor.darkGreen
COLOR_SELECT = "#F58A2C"
ALBUM_ART_PATH = "backup_album.jpg"

ORCHESTRA_LIST = ["Enrique RODRÍGUEZ", "Adolfo CARABELLI", 'Roberto CALO', 'Donato RACCIATTI', "Julio DE CARO", "Rodolfo BIAGI", "Antonio RODIO", "Alfredo DE ANGELIS",
                  "Osvaldo FRESEDO", "Ricardo TANTURI", "Alfredo GOBBI", "Juan MAGLIO", "Francisco CANARO", "Roberto FIRPO", "José BASSO",
                  "Florindo SASSONE", "Héctor VARELA","Astor PIAZZOLLA", "Francisco ROTUNDO", "Francisco LOMUTO", "Orquesta TÍPICA VICTOR", 
                  "Edgardo DONATO", "FRANCINI-PONTIER",
                # "Antonio BONAVENA", "FRANCINI-PONTIER",
                  '--','--','--','--','--','--','--',
                # "Juan D'ARIENZO", "Carlos DI SARLI", "Osvaldo PUGLIESE", "Aníbal TROILO", 
                # "Miguel CALO", "Lucio DEMARE", "Pedro LAURENZ", "Ricardo TANTURI", 
                # "Ángel D'AGOSTINO", "Rodolfo BIAGI",
                # "Francisco CANARO", "Francisco LOMUTO", "Roberto FIRPO", "Julio DE CARO", 
                # "Adolfo CARABELLI", "Juan MAGLIO", "Rafael CANARO",
                # "Orquesta TÍPICA VICTOR", "Enrique RODRÍGUEZ", "Alfredo DE ANGELIS", "Osvaldo FRESEDO", "Edgardo DONATO", 
                # "Ricardo MALERBA", "Domingo FEDERICO", "José GARCIA", "José BASSO", "Alfredo GOBBI", "Astor PIAZZOLLA", 
                # "Horacio SALGÁN", "Enrique FRANCINI", "FRANCINI-PONTIER", "Armando PONTIER", "Osmar MADERNA", "Fulvio SALAMANCA", "Manuel BUZÓN",
                # "Quinteto PIRINCHO (Francisco Canaro)", "Cuarteto Típico Roberto FIRPO", "Cuarteto Aníbal TROILO"
                # "Francisco ROTUNDO", "Florindo SASSONE", "Héctor VARELA",
                # "Juan MAGLIO"
                # "Osvaldo MANZI y El Octeto Marabú", "Ricardo PEDEVILLA", "Ángel DOMINGUEZ", "José SALA",
                # "Orquesta Típica SANS SOUCI", "Orquesta Típica FERNÁNDEZ FIERRO", "TANGO BARDO", "Orquesta Típica SILENCIO", "Orquesta Típica FERVOR DE BUENOS AIRES"
                  ]

SOLOIST_LIST = ["Ángel VARGAS", "Alberto CASTILLO", "Alberto MARINO", "Alberto MORAN", "Francisco FIORENTINO", "Roberto GOYENECHE","Roberto CHANEL"
                ,'--','--','--','--','--','--','--','--','--','--','--','--','--','--','--','--','--','--',]

class CenteredItemDelegate(QStyledItemDelegate):
    def initStyleOption(self, option, index):
        super().initStyleOption(option, index)
        option.displayAlignment = Qt.AlignmentFlag.AlignCenter

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("ElRecodoTagger")
        self.order_by = 'date'
        self.source = 'FREE'

        self.is_mode_orchestra = True
        
        self.batch_id = 1
        self.selected_orchestra = ''
        self.selected_singer = ''
        self.selected_year = ''
        self.labels = ['Id', 'Title', 'Orchestra', 'Singer', 'Date', 'Genre', 'Count']
        self.distinct_years_count = 0
        self.is_mapped = False
        self.showOnlyGoodGenres = True

        self.selected_orchestra_button_text = ''
        self.selected_singer_button_text = ''        
        self.selected_year_button_text = ''

        self.orchestra_search_results_backup = None

        self.collator = pyuca.Collator() 

        main_widget = QWidget()
        main_layout = QHBoxLayout()
        main_widget.setLayout(main_layout)
        self.setCentralWidget(main_widget)

        db_splitter = QSplitter(Qt.Orientation.Vertical)
        db_splitter2 = QSplitter(Qt.Orientation.Horizontal)

        self.menu_singers_list = QSplitter(Qt.Orientation.Vertical)
        self.menu_years_list = QSplitter(Qt.Orientation.Vertical)

        db_splitter2.addWidget(self.display_orchestra_button_list())
        db_splitter2.addWidget(self.menu_singers_list)
        db_splitter2.addWidget(self.menu_years_list)
        db_splitter2.addWidget(self.display_database())

        db_splitter.addWidget(self.display_menu_database())
        db_splitter.addWidget(db_splitter2)

        match_splitter = QSplitter(Qt.Orientation.Vertical)
        match_splitter.addWidget(self.display_menu_match())
        match_splitter.addWidget(self.display_match())

        self.list_widget_dirs = QListWidget()
        self.list_widget_dirs.setMaximumHeight(200)
        self.list_widget_dirs.itemClicked.connect(self.handle_directory_click)
        self.list_widget_dirs.setItemDelegate(CenteredItemDelegate())

        self.list_widget_files = QListWidget()
        self.list_widget_files.setStyleSheet("QListWidget::item:selected { background-color: "+COLOR_SELECT+"; color: black; }")
        self.list_widget_files.itemClicked.connect(self.handle_file_click)

        dir_file_splitter = QSplitter(Qt.Orientation.Vertical)
        dir_file_splitter.addWidget(self.display_menu_dir())
        dir_file_splitter.addWidget(self.list_widget_dirs)
        dir_file_splitter.addWidget(self.list_widget_files)
        
        # Create splitter for the main window
        splitter = QSplitter(Qt.Orientation.Horizontal)
        splitter.addWidget(dir_file_splitter)
        splitter.addWidget(match_splitter)
        splitter.addWidget(db_splitter)

        # Add main splitter to main layout
        main_layout.addWidget(splitter)

        self.populate_lists()

        self.selected_filenames = []
        self.selected_db_rows = []

    def display_menu_dir(self):
        menu_dir = QSplitter(Qt.Orientation.Vertical)
        menu_nav = QSplitter(Qt.Orientation.Horizontal)
        menu_source = QSplitter(Qt.Orientation.Horizontal)

        self.back_button = QPushButton("Back")
        self.back_button.clicked.connect(self.go_back)
        menu_nav.addWidget(self.back_button)

        self.path_textbox = QLineEdit()
        self.path_textbox = QLineEdit(DEFAULT_PATH)
        menu_nav.addWidget(self.path_textbox)

        self.go_button = QPushButton("Go to Path")
        self.go_button.clicked.connect(self.go_to_path)
        menu_nav.addWidget(self.go_button)

        label_album = QLabel()
        label_album.setText("Album:")
        menu_source.addWidget(label_album)
        self.album_textbox = QLineEdit()
        menu_source.addWidget(self.album_textbox)
        self.album_textbox.setText('XXX - Su Obra Completa')

        label_source = QLabel()
        label_source.setText("Source:")
        menu_source.addWidget(label_source)
        
        self.source_free_radio_button = QRadioButton("FREE")
        self.source_free_radio_button.setChecked(True)
        self.source_free_radio_button.toggled.connect(self.source_radio_button_changed)
        menu_source.addWidget(self.source_free_radio_button)

        self.source_ttt_radio_button = QRadioButton("TTT")
        self.source_ttt_radio_button.toggled.connect(self.source_radio_button_changed)
        menu_source.addWidget(self.source_ttt_radio_button)

        self.source_tt_radio_button = QRadioButton("TT")
        self.source_tt_radio_button.toggled.connect(self.source_radio_button_changed)
        menu_source.addWidget(self.source_tt_radio_button)

        self.rb_group_source = QButtonGroup(self)
        self.rb_group_source.addButton(self.source_free_radio_button)
        self.rb_group_source.addButton(self.source_ttt_radio_button)
        self.rb_group_source.addButton(self.source_tt_radio_button)

        menu_dir.addWidget(menu_nav)
        menu_dir.addWidget(menu_source)
        return menu_dir
    
    def display_menu_match(self):
        menu_match = QSplitter(Qt.Orientation.Horizontal)

        menu_match_match = QSplitter(Qt.Orientation.Vertical)
        menu_match_remove = QSplitter(Qt.Orientation.Vertical)

        self.auto_match_button = QPushButton("Auto-Match")
        self.auto_match_button.clicked.connect(self.handle_auto_match)
        menu_match_match.addWidget(self.auto_match_button)
        self.match_button = QPushButton("Match")
        self.match_button.clicked.connect(self.handle_match)
        menu_match_match.addWidget(self.match_button)
        self.match_by_id_button = QPushButton("Match By Id")
        self.match_by_id_button.clicked.connect(self.handle_all_by_id)
        menu_match_match.addWidget(self.match_by_id_button)

        self.tag_all_button = QPushButton("Tag All")
        self.tag_all_button.clicked.connect(self.handle_tag_all)

        self.remove_match_button = QPushButton("Remove")
        self.remove_match_button.clicked.connect(self.handle_remove_match)
        menu_match_remove.addWidget(self.remove_match_button)
        self.remove_all_match_button = QPushButton("Remove All")
        self.remove_all_match_button.clicked.connect(self.handle_remove_all_match)
        menu_match_remove.addWidget(self.remove_all_match_button)
        self.print_tags_button = QPushButton("Print Tags")
        self.print_tags_button.clicked.connect(self.handle_print_tags)
        menu_match_remove.addWidget(self.print_tags_button)

        menu_match.addWidget(menu_match_match)
        menu_match.addWidget(self.tag_all_button)
        menu_match.addWidget(menu_match_remove)

        return menu_match

    def display_match(self):
        self.list_widget_matchings = QListWidget()
        self.list_widget_matchings.setStyleSheet("QListWidget::item:selected { background-color: "+COLOR_SELECT+"; color: black; }")
        self.list_widget_matchings.itemSelectionChanged.connect(self.handle_matching_item_selection)
        return self.list_widget_matchings

    def display_menu_database(self):
        menu_hor = QSplitter(Qt.Orientation.Horizontal)
        menu_db = QSplitter(Qt.Orientation.Vertical)
        menu_db_1 = QSplitter(Qt.Orientation.Horizontal)
        
        validator = QIntValidator(0, 99)  # Set the range of allowed values

        label_title = QLabel()
        label_title.setText("Title:")
        menu_db_1.addWidget(label_title)
        self.title_textbox = QLineEdit()
        menu_db_1.addWidget(self.title_textbox)

        label_order = QLabel()
        label_order.setText("Order:")
        menu_db_1.addWidget(label_order)

        self.title_radio_button = QRadioButton("Title")
        self.title_radio_button.toggled.connect(self.order_radio_button_changed)
        menu_db_1.addWidget(self.title_radio_button)

        self.date_radio_button = QRadioButton("Date")
        self.date_radio_button.setChecked(True)
        self.date_radio_button.toggled.connect(self.order_radio_button_changed)
        menu_db_1.addWidget(self.date_radio_button)

        self.rb_group_order = QButtonGroup(self)
        self.rb_group_order.addButton(self.title_radio_button)
        self.rb_group_order.addButton(self.date_radio_button)

        self.search_button = QPushButton("Search")
        self.search_button.clicked.connect(self.handle_search_database)

        self.checkbox_is_mapped = QCheckBox("Is Mapped")
        self.checkbox_is_mapped.stateChanged.connect(self.handle_checkbox_is_mapped_change)

        menu_db.addWidget(menu_db_1)

        menu_hor.addWidget(self.search_button)
        menu_hor.addWidget(self.checkbox_is_mapped)
        menu_hor.addWidget(menu_db)

        return menu_hor

    def handle_checkbox_is_mapped_change(self):
        if self.checkbox_is_mapped.isChecked():
            self.is_mapped = True
        else:
            self.is_mapped = False
        
        self.populate_database_table()
            
    def display_orchestra_button_list(self):

        self.menu_orchestra_list = QSplitter(Qt.Orientation.Vertical)

        while self.menu_orchestra_list.count() > 0:
            self.menu_orchestra_list.widget(0).setParent(None)

        if self.is_mode_orchestra:
            artist_list = ORCHESTRA_LIST
        else:
            artist_list = SOLOIST_LIST

        for orchestra in sorted(artist_list,  key=self.collator.sort_key):
            self.btn_orchestra = QPushButton(orchestra)
            self.btn_orchestra.clicked.connect(lambda checked, btn_text=orchestra: self.handle_orchestra_buttons(btn_text))
            self.btn_orchestra.setFixedWidth(170)
            self.menu_orchestra_list.addWidget(self.btn_orchestra)

        return self.menu_orchestra_list

    def handle_orchestra_buttons(self, orchestra):
        if(self.selected_orchestra == orchestra):
            self.selected_orchestra = None
        else:
            self.selected_orchestra = orchestra.replace('\'', '\'\'')

        self.selected_orchestra_button_text = orchestra
        self.selected_singer = ''        
        self.display_singers_button_list(orchestra.replace('\'', '\'\''))
        self.highlight_orchestra_button_by_text(orchestra)

    def display_singers_button_list(self, orchestra_name):

        while self.menu_singers_list.count() > 0:
            self.menu_singers_list.widget(0).setParent(None)

        conn = DatabaseConnection().get_connection()
        c = conn.cursor()

        if self.is_mode_orchestra:
            c.execute(f"SELECT DISTINCT singer FROM singer_orchestra WHERE orchestra = '{orchestra_name}' AND singer <> 'Instrumental'")
        else:
            c.execute(f"SELECT DISTINCT director FROM soloist_director WHERE soloist = '{orchestra_name}'")

        second_artists = c.fetchall()

        self.button = QPushButton('All')
        self.button.setFixedWidth(170)
        self.button.clicked.connect(lambda checked, btn_name='All': self.on_singer_button_click('All'))
        self.menu_singers_list.addWidget(self.button)
    
        if self.is_mode_orchestra:
            self.button = QPushButton('Instrumental')
            self.button.setFixedWidth(170)
            self.button.clicked.connect(lambda checked, btn_name='Instrumental': self.on_singer_button_click('Instrumental'))
            self.menu_singers_list.addWidget(self.button)

        second_artist_names = [tup[0] for tup in second_artists]
        for sa_name in sorted(second_artist_names,  key=self.collator.sort_key):
            self.button = QPushButton(sa_name)
            self.button.setFixedWidth(170)
            self.button.clicked.connect(lambda checked, btn_name=sa_name: self.on_singer_button_click(btn_name))
            self.menu_singers_list.addWidget(self.button)

        self.selected_year = ''
        self.get_years_of_singer_orchestra()

        self.populate_database_table(True)

    def get_years_of_singer_orchestra(self):

        while self.menu_years_list.count() > 0:
            self.menu_years_list.widget(0).setParent(None)

        conn = DatabaseConnection().get_connection()
        cursor = conn.cursor()

        if self.is_mode_orchestra:
            cursor.execute(f'''
                       SELECT DISTINCT strftime('%Y', date) FROM recordings WHERE orchestra = '{self.selected_orchestra}' AND singers LIKE '%{self.selected_singer}%'
                       ''')
        else :
            cursor.execute(f'''
                       SELECT DISTINCT strftime('%Y', date) FROM recordings WHERE soloist LIKE '%{self.selected_orchestra}%' AND director LIKE '%{self.selected_singer}%'
                       ''')


        # Fetch all distinct years
        distinct_years = sorted([row[0] for row in cursor.fetchall()])
        self.distinct_years_count = len(distinct_years)
        
        is_first_even = 0
        if(int(distinct_years[0]) % 2 == 0):
            is_first_even = 0
        else:
            is_first_even = 1

        if self.distinct_years_count > 30:
            distinct_years = [year for year in distinct_years if int(year) % 2 == is_first_even]

        self.button = QPushButton('All')
        self.button.setFixedWidth(50)
        self.button.clicked.connect(lambda checked, btn_name='All': self.on_year_button_click('All'))
        self.menu_years_list.addWidget(self.button)

        for year in distinct_years:
            self.btn_year = QPushButton(year)
            self.btn_year.setFixedWidth(50)
            self.btn_year.clicked.connect(lambda checked, btn_name=year: self.on_year_button_click(btn_name))
            self.menu_years_list.addWidget(self.btn_year)

        cursor.close()

    def highlight_year_button_by_text(self, text):
        for button in self.menu_years_list.children():
            if isinstance(button, QPushButton):
                if button.text() == text:
                    button.setStyleSheet("background-color: #25D072; color: black;")
                else:
                    button.setStyleSheet("")

    def highlight_singer_button_by_text(self, text):
        for button in self.menu_singers_list.children():
            if isinstance(button, QPushButton):
                if button.text() == text:
                    button.setStyleSheet("background-color: #25D072; color: black;")
                else:
                    button.setStyleSheet("")

    def highlight_orchestra_button_by_text(self, text):
        for button in self.menu_orchestra_list.children():
            if isinstance(button, QPushButton):
                if button.text() == text:
                    button.setStyleSheet("background-color: #25D072; color: black;")
                else:
                    button.setStyleSheet("")

    def on_year_button_click(self, year):
        if(self.selected_year == year or year == 'All'):
            self.selected_year = ''
        else:
            self.selected_year = year

        self.selected_year_button_text = year
        self.populate_database_table()
        self.highlight_year_button_by_text(year)

    def on_singer_button_click(self, singer):
        if(self.selected_singer == singer or singer == 'All'):
            self.selected_singer = ''
        else:
            self.selected_singer = singer.replace('\'', '\'\'')

        self.selected_singer_button_text = singer
        self.selected_year = ''
        self.get_years_of_singer_orchestra()

        self.populate_database_table()
        self.highlight_singer_button_by_text(singer)

    def on_orchestra_text_changed(self, text):
        self.singer_textbox.setText("")

    # def on_mindate_text_changed(self, text):
    #     self.maxdate_textbox.setText("")

    def handle_search_database(self):
        self.populate_database_table()

    def display_database(self):
        self.table_widget_db = QTableWidget()
        self.table_widget_db.horizontalHeader().setSectionResizeMode(QHeaderView.ResizeMode.Stretch)
        self.table_widget_db.setSelectionBehavior(QTableWidget.SelectionBehavior.SelectRows)
        self.table_widget_db.setSelectionMode(QTableWidget.SelectionMode.SingleSelection)
        self.table_widget_db.setMaximumWidth(1200)
        self.table_widget_db.setStyleSheet("QTableWidget::item:selected { background-color: "+COLOR_SELECT+"; color: black; }")
        # self.table_widget_db.cellClicked.connect(self.handle_database_row_click)

        self.table_widget_db.setColumnCount(len(self.labels))
        self.table_widget_db.setHorizontalHeaderLabels(self.labels)

        header = self.table_widget_db.horizontalHeader()
        header.setSectionResizeMode(0, QHeaderView.ResizeMode.ResizeToContents)
        header.setSectionResizeMode(1, QHeaderView.ResizeMode.ResizeToContents)
        header.setSectionResizeMode(4, QHeaderView.ResizeMode.ResizeToContents)
        header.setSectionResizeMode(5, QHeaderView.ResizeMode.ResizeToContents)

        # self.table_widget_db.setMinimumHeight(900)
        return self.table_widget_db

    def populate_lists(self):
        self.current_directory = os.getcwd()
        self.populate_directory_list()
        self.go_to_path()

    def order_radio_button_changed(self):
        if self.title_radio_button.isChecked():
            self.order_by = 'title'
        elif self.date_radio_button.isChecked():
            self.order_by = 'date'

        self.populate_database_table()

    def source_radio_button_changed(self):
        if self.source_free_radio_button.isChecked():
            self.source = 'FREE'
        elif self.source_ttt_radio_button.isChecked():
            self.source = 'TTT'
        elif self.source_tt_radio_button.isChecked():
            self.source = 'TT'
        print("Source: ", self.source)
        self.populate_directory_list()


    def handle_matching_item_selection(self):
        selected_items = self.list_widget_matchings.selectedItems()
        if selected_items:
            selected_item_text = selected_items[0].text()
            filename, title, music_id = selected_item_text.split('|')
    
            # Clear selection from other widgets
            self.list_widget_files.clearSelection()
            self.table_widget_db.clearSelection()
    
            # Find corresponding items in list_widget_files and table_widget_db
            for index in range(self.list_widget_files.count()):
                item = self.list_widget_files.item(index)
                if item and item.text().lower() == filename.lower():
                    item.setSelected(True)
                    item.setBackground(COLOR_MATCH)
                    self.list_widget_files.scrollToItem(item, QAbstractItemView.ScrollHint.PositionAtCenter)
                    break
                
            for row in range(self.table_widget_db.rowCount()):
                if self.table_widget_db.item(row, 0).text() == music_id:
                    self.table_widget_db.selectRow(row)
                    for column in range(self.table_widget_db.columnCount()):
                        self.table_widget_db.item(row, column).setBackground(COLOR_MATCH)
                    break
        else:
            # If no item is selected in list_widget_matchings, clear selections and reset colors
            self.list_widget_files.clearSelection()
            self.table_widget_db.clearSelection()
            for index in range(self.list_widget_files.count()):
                self.list_widget_files.item(index).setBackground(Qt.GlobalColor.transparent)
            for row in range(self.table_widget_db.rowCount()):
                for column in range(self.table_widget_db.columnCount()):
                    self.table_widget_db.item(row, column).setBackground(Qt.GlobalColor.transparent)

    def remove_parentheses(self, text):
        pattern = r'\(.*?\)'
        result = re.sub(pattern, '', text)
        return result

    def handle_auto_match(self):
        self.selected_filenames.clear()
        self.selected_db_rows.clear()

        db_title_keywords = []
        filename_keywords = []

        for index in range(self.table_widget_db.rowCount()):
            title_item = self.table_widget_db.item(index, 1)
            singer_item = self.table_widget_db.item(index, 2)
            if title_item:
                title = unidecode(title_item.text().lower())
                # Split title and get the two longest words
                title_words = title.split()
                title_words = [word for word in title_words if word != 'instrumental' or word != 'Remasterizado']
                title_words.sort(key=len, reverse=True)
                db_title_keywords = title_words[:2] if len(title_words) >= 2 else title_words

                for file_index in range(self.list_widget_files.count()):
                    file_item = self.list_widget_files.item(file_index)
                    if file_item:
                        filename = unidecode(self.remove_parentheses(file_item.text().lower().replace('-', ' ').replace(singer_item.text().lower(), '')))
                        filename_words = re.split(' |_', filename.split('.')[0])
                        filename_words = [word for word in filename_words if word != 'instrumental' and not word.isnumeric()]
                        filename_words.sort(key=len, reverse=True)
                        filename_keywords = filename_words[:2] if len(filename_words) >= 2 else filename_words

                        print(db_title_keywords, filename_keywords)

                        # If the two longest words match, add to match list
                        # Adjust the if statement to match for 1 or 2 words
                        if (len(db_title_keywords) == 1 and db_title_keywords[0] in filename_keywords) or \
                            (len(filename_keywords) == 1 and filename_keywords[0] in db_title_keywords) or \
                            set(db_title_keywords) == set(filename_keywords):
                                
                            item_text = f"{file_item.text().lower()}|{title_item.text()}|{self.table_widget_db.item(index, 0).text()}"
                            list_item = QListWidgetItem(item_text)
                            self.list_widget_matchings.addItem(list_item)

                            # Color backgrounds
                            file_item.setBackground(COLOR_MATCH)

                            for col in range(self.table_widget_db.columnCount()):
                                self.table_widget_db.item(index, col).setBackground(COLOR_MATCH)

                            # Add selected items to the respective lists
                            self.selected_filenames.append(file_item.text())
                            selected_row = self.table_widget_db.item(index, 0).text()
                            if selected_row != -1:
                                self.selected_db_rows.append(selected_row)

                            break
                           

    def color_selected_db_rows(self):
        # Color the rows corresponding to selected_db_rows
        for music_id in self.selected_db_rows:
            for row in range(self.table_widget_db.rowCount()):
                item = self.table_widget_db.item(row, 0)  # Assuming music_id is in the first column
                if item and item.text() == music_id:
                    for col in range(self.table_widget_db.columnCount()):
                        self.table_widget_db.item(row, col).setBackground(COLOR_MATCH)

    def handle_remove_match(self):
        selected_matching_item = self.list_widget_matchings.currentItem()

        if(selected_matching_item == None):
            return

        matching_pair = selected_matching_item.text().split('|')
        filename_to_remove = matching_pair[0]
        music_id_to_remove = matching_pair[2]

        for index in range(self.list_widget_files.count()):
            item = self.list_widget_files.item(index)
            if item.text() == matching_pair[0]:
                item.setBackground(Qt.GlobalColor.transparent)

        for index in range(self.table_widget_db.rowCount()):
            item = self.table_widget_db.item(index, 0)
            if item.text() == matching_pair[2]:
                for col in range(self.table_widget_db.columnCount()):
                    self.table_widget_db.item(index, col).setBackground(Qt.GlobalColor.transparent)
        
        for index in range(self.list_widget_matchings.count()):
            item = self.list_widget_matchings.item(index)
            if(item == None):
                pass
            elif item.text() == selected_matching_item.text():
                self.list_widget_matchings.takeItem(index)
        
        if filename_to_remove in self.selected_filenames:
            self.selected_filenames.remove(filename_to_remove)

        if music_id_to_remove in self.selected_db_rows:
            self.selected_db_rows.remove(music_id_to_remove)

    def handle_remove_all_match(self):
        for index in range(self.list_widget_files.count()):
            item = self.list_widget_files.item(index)
            item.setBackground(Qt.GlobalColor.transparent)

        for index in range(self.table_widget_db.rowCount()):
            item = self.table_widget_db.item(index, 0)
            for col in range(self.table_widget_db.columnCount()):
                self.table_widget_db.item(index, col).setBackground(Qt.GlobalColor.transparent)
        
        for index in range(self.list_widget_matchings.count()):
            self.list_widget_matchings.takeItem(0)

        self.list_widget_matchings.clearSelection()
        self.table_widget_db.clearSelection()
        self.list_widget_files.clearSelection() # ???

        self.selected_filenames.clear()
        self.selected_db_rows.clear()

    def handle_all_by_id(self):
        self.selected_filenames.clear()
        self.selected_db_rows.clear()

        for index in range(self.table_widget_db.rowCount()):
            db_music_id = self.table_widget_db.item(index, 0).text()
            if db_music_id:
                # Iterate through file list to find matches
                for file_index in range(self.list_widget_files.count()):
                    file_item = self.list_widget_files.item(file_index)
                    if file_item:
                        filename = file_item.text().lower()
                        file_music_id = filename.split('.')[0].split('_')[-1]

                        # If the longest word matches, add to match list
                        if db_music_id == file_music_id:
                            # Add to match list
                            item_text = f"{filename}|{self.table_widget_db.item(index, 1).text()}|{self.table_widget_db.item(index, 0).text()}"
                            list_item = QListWidgetItem(item_text)
                            self.list_widget_matchings.addItem(list_item)

                            # Color backgrounds
                            file_item.setBackground(COLOR_MATCH)

                            for col in range(self.table_widget_db.columnCount()):
                                self.table_widget_db.item(index, col).setBackground(COLOR_MATCH)

                             # Add selected items to the respective lists
                            self.selected_filenames.append(file_item.text())
                            selected_row = self.table_widget_db.item(index, 0).text()
                            if selected_row != -1:
                                self.selected_db_rows.append(selected_row)

                            break

    def handle_match(self):
        selected_file_item = self.list_widget_files.currentItem()
        selected_row = self.table_widget_db.currentRow()

        if(selected_file_item == None or selected_row == -1):
            return

        if selected_file_item:
            selected_file = selected_file_item.text()

        music_id_item = self.table_widget_db.item(selected_row, 0)
        if music_id_item:
            music_id_content = music_id_item.text()

        item_text = f"{selected_file}|{self.table_widget_db.item(selected_row, 1).text()}|{music_id_content}"
        list_item = QListWidgetItem(item_text)
        self.list_widget_matchings.addItem(list_item)

        selected_file_item.setBackground(COLOR_MATCH)
        for col in range(self.table_widget_db.columnCount()):
            self.table_widget_db.item(selected_row, col).setBackground(COLOR_MATCH)

        self.selected_db_rows.append(self.table_widget_db.item(selected_row, 0).text())
        self.selected_filenames.append(selected_file_item.text())
    
        self.list_widget_files.clearSelection()
        self.table_widget_db.clearSelection()

    def handle_print_tags(self):
        filename = os.path.join(self.current_directory, self.list_widget_files.currentItem().text())
        extension = filename.split('.')[-1].lower()

        print(filename)

        if extension == 'mp3':
            song = MP3(filename, ID3=ID3)
        elif extension == 'flac':
            song = FLAC(filename)

        for tag in song.tags:
            print(tag)

        # with taglib.File(filename, save_on_exit=True) as song:
        #     for tag in song.tags:
        #         print(f"{tag}  ->  {song.tags[tag]}")
        # print(filename, "DONE")

    def extract_album_art(self, song):
        # Extract album art and store it
        albumart_found = False
        if song.tags is not None:
            for tag in song.tags.values():
                if isinstance(tag, APIC):
                    with open(ALBUM_ART_PATH, "wb") as img:
                        albumart_found = True
                        img.write(tag.data)
                    break
        song.save()
        return albumart_found

    def handle_tag_all(self):
        for item in range(self.list_widget_matchings.count()):
            matchTextItems = self.list_widget_matchings.item(item).text().split('|')
            extension = matchTextItems[0].split('.')[-1].lower()
            filename = os.path.join(self.current_directory, matchTextItems[0])
            
            recording = self.getRecordingInfoByMusicId(matchTextItems[2])
            label = recording.label.title() if recording.label != 'None' else ''
            composer = recording.composer.split(' y ') if recording.composer != 'None' else ''
            lyricist = recording.author.split(' y ') if recording.author != 'None' else ''
            first_artist = recording.orchestra.title() if self.is_mode_orchestra else recording.soloist.title()
            second_artist = recording.singers.split(' y ') if self.is_mode_orchestra else recording.director.title()

            fdate = self.parseDate(recording.date)
            year = self.parseYear(recording.date) 

            if extension == 'mp3':
                song = MP3(filename, ID3=ID3)
                albumart_found = self.extract_album_art(song)

                try:
                    mp3tags = ID3(filename)
                except ID3NoHeaderError:
                    mp3tags = ID3()
                    mp3tags.save(filename, v2_version=4)

                mp3tags.delete()
                
                if albumart_found:
                    with open(ALBUM_ART_PATH, "rb") as img:
                        album_art_data = img.read()

                    mp3tags['APIC'] = APIC(
                        encoding=3,
                        mime='image/jpeg',
                        type=3, desc=u'Cover',
                        data=album_art_data
                    )

                mp3tags['TIT2'] = TIT2(encoding=3, text=recording.title)
                mp3tags['TPE1'] = TPE1(encoding=3, text=', '.join(aa for aa in second_artist))
                mp3tags['TPE2'] = TPE2(encoding=3, text=first_artist)

                # mp3tags['TSOP'] = TSOP(encoding=3, text=os.path.basename(self.current_directory))
                mp3tags['TXXX:ALBUMARTISTSORT'] = TXXX(encoding=3, desc='ALBUMARTISTSORT', text=os.path.basename(root))

                if self.source == 'FREE':
                    mp3tags['TALB'] = TALB(encoding=3, text=self.album_textbox.text())

                mp3tags['TCOM'] = TCOM(encoding=3, text=', '.join(aa for aa in composer))
                mp3tags['TCON'] = TCON(encoding=3, text=recording.style.title())
                mp3tags['TPUB'] = TPUB(encoding=3, text=label)

                if not self.is_mode_orchestra or (self.is_mode_orchestra and second_artist != 'Instrumental'):
                    mp3tags['TEXT'] = TEXT(encoding=3, text=', '.join(aa for aa in lyricist))
                    mp3tags['USLT'] = USLT(encoding=3, text=recording.lyrics)
                    mp3tags['TXXX:UNSYNCEDLYRICS'] = TXXX(encoding=3, desc='UNSYNCEDLYRICS', text=recording.lyrics) # with mp3tag, it is USLT with Unix(LF)

                # mp3tags['GRID'] = GRID(encoding=3, text=self.source)
                mp3tags['GRP1'] = GRP1(encoding=3, text=self.source)
                mp3tags['TXXX:BARCODE'] = TXXX(encoding=3, desc='BARCODE', text="ERT-"+recording.id)

                mp3tags['TYER'] = TYER(encoding=3, text=year)
                mp3tags['TDRC'] = TDRC(encoding=3, text=fdate)
                mp3tags['TDOR'] = TDOR(encoding=3, text=fdate)

                # Save changes using ID3v2.4
                mp3tags.save(filename, v2_version=4)

            elif extension == 'flac':
                flac = FLAC(filename)
                flac.delete()

                flac['title'] = recording.title
                flac['artist'] = ', '.join(aa for aa in second_artist)
                flac['albumartist'] = first_artist
                # flac['artistsort'] = os.path.basename(self.current_directory)
                flac['albumartistsort'] = os.path.basename(self.current_directory)
                flac['genre'] = recording.style.title()
                flac['composer'] = ', '.join(aa for aa in composer)

                flac['date'] = fdate
                flac['year'] = year
                flac['originaldate'] = fdate

                flac['barcode'] = "ERT-"+recording.id
                flac['grouping'] = self.source
                flac['organization'] = label

                if self.source == 'FREE':
                    flac['album'] = self.album_textbox.text()

                if not self.is_mode_orchestra or (self.is_mode_orchestra and second_artist != 'Instrumental'):
                    flac["lyricist"] = ', '.join(aa for aa in lyricist)
                    flac["unsyncedlyrics"] = recording.lyrics  # FLAC, MP3

                flac.save()

            else:
                print(f"Unsupported file format {extension} for {filename}")
                continue

            second_artist_name = recording.singers if self.is_mode_orchestra else recording.director.title()
            new_filename = unidecode(f'{self.parseDate(recording.date).replace("-", "")}__{recording.title.replace(" ", "_").lower()}__{second_artist_name.replace(" ", "_").lower()}__{recording.style.replace(" ", "_").lower()}__{recording.id}.{extension}')
            new_filepath = os.path.join(self.current_directory, new_filename.replace('dir._', '').replace("?", ""))            

            os.rename(filename, new_filepath)

            self.updateRecording(matchTextItems[2], filename)

            print(filename, '  ->  DONE')
        
        self.populate_directory_list()
        for index in range(self.list_widget_matchings.count()):
            self.list_widget_matchings.takeItem(0)
        self.list_widget_matchings.clearSelection()
        self.populate_database_table()

    def updateRecording(self, music_id, filename):
        with DatabaseConnection().get_connection() as conn:
            updateCommand = f'''
                UPDATE recordings 
                SET is_mapped = true, 
                map_date = DATE('now'), 
                batch_id = {self.batch_id}, 
                relative_file_path = '{self.replaceSingleTick(filename)}', 
                audio_source = '{self.source}' 
                WHERE music_id = {music_id}
                '''
            
            conn.execute(updateCommand)
            conn.commit()
            
            print(f"Record with ID {music_id} updated successfully.")


    def getRecordingInfoByMusicId(self, music_id):
        with DatabaseConnection().get_connection() as conn:
            c = conn.execute(f"SELECT title, orchestra, singers, date, style, composer, author, label, lyrics, duplicate_count, soloist, director, audio_source FROM recordings WHERE music_id = '{music_id}'")
            for row in c:
                recording = Recording(music_id, row[0], row[1], row[2], row[10], row[11], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[12])
            c.close()
        return recording

    def populate_directory_list(self):
        self.list_widget_dirs.clear()
        self.list_widget_files.clear()

        for item in os.listdir(self.current_directory):
            item_path = os.path.join(self.current_directory, item)
            if os.path.isfile(item_path):
                if item.lower().endswith(('.mp3', '.m4a', '.flac', '.aif')):
                    list_item = QListWidgetItem(item)
                    self.list_widget_files.addItem(list_item)

            elif os.path.isdir(item_path):
                list_item = QListWidgetItem(item)
                self.list_widget_dirs.addItem(list_item)

    def go_back(self):
        self.current_directory = os.path.dirname(self.current_directory)
        self.populate_directory_list()

        if self.list_widget_dirs.count() != 0:
            self.list_widget_dirs.setVisible(True)
        
        self.path_textbox.setText(self.current_directory)

    def go_to_path(self):
        path = self.path_textbox.text().strip()
        if path and os.path.isdir(path):
            self.current_directory = path
            self.populate_directory_list()

        if self.list_widget_dirs.count() == 0:
            self.list_widget_dirs.setVisible(False)
        
        self.path_textbox.setText(self.current_directory)

    def handle_directory_click(self, item):
        self.current_directory = os.path.join(self.current_directory, item.text())
        self.populate_directory_list()

        if self.list_widget_dirs.count() == 0:
            self.list_widget_dirs.setVisible(False)

        self.path_textbox.setText(self.current_directory)

    def handle_file_click(self, item):
        # fullpath = os.path.join(self.current_directory, item.text())
        return

    # def handle_database_row_click(self, row, column):
    #     item_1 = self.table_widget_db.item(row, 0)
    #     item_2 = self.table_widget_db.item(row, 1)

    def replaceSingleTick(self, input):
        return input.replace("'", "''")

    def populate_database_table(self, is_orchestra_changed=False):
        next_year = '2050'
        if(self.selected_year != ''):
            if self.distinct_years_count > 30:
                next_year = str(int(self.selected_year) + 2)
            else:
                next_year = str(int(self.selected_year) + 1)

        if self.is_mode_orchestra:
            query = f'''
                SELECT music_id, title, orchestra, singers,
                date, 
                CASE 
                    WHEN style = 'TANGO' THEN 'T'
                    WHEN style = 'MILONGA' THEN 'M'
                    WHEN style = 'VALS' THEN 'V'
                    ELSE style END, 
                CASE WHEN duplicate_count IS NULL THEN '' ELSE duplicate_count END
                FROM recordings 
                WHERE
                    (orchestra = '{self.selected_orchestra}') AND     
                    (singers LIKE '%{self.selected_singer}%') AND 
                    title LIKE '%{self.replaceSingleTick(self.title_textbox.text())}%' AND 
                    date >= date('{self.selected_year if self.selected_year else '1890'}{DATE_ZERO_TIME}') AND 
                    date < date('{next_year if next_year else '2050'}{DATE_ZERO_TIME}') AND
                    is_mapped = {self.is_mapped} AND
                    CASE WHEN {self.showOnlyGoodGenres} then style IN ('TANGO', 'MILONGA', 'VALS', 'CANDOMBE') END = 1
                ORDER BY {self.order_by}
                '''
        else:
            query = f'''
                SELECT music_id, title, soloist, director,
                date, 
                CASE 
                    WHEN style = 'TANGO' THEN 'T'
                    WHEN style = 'MILONGA' THEN 'M'
                    WHEN style = 'VALS' THEN 'V'
                    ELSE style END, 
                CASE WHEN duplicate_count IS NULL THEN '' ELSE duplicate_count END
                FROM recordings 
                WHERE
                    (soloist = '{self.selected_orchestra}') AND     
                    (director LIKE '%{self.selected_singer}%') AND 
                    title LIKE '%{self.replaceSingleTick(self.title_textbox.text())}%' AND 
                    date >= date('{self.selected_year if self.selected_year else '1890'}{DATE_ZERO_TIME}') AND 
                    date < date('{next_year if next_year else '2050'}{DATE_ZERO_TIME}') AND
                    is_mapped = {self.is_mapped} AND
                    CASE WHEN {self.showOnlyGoodGenres} then style IN ('TANGO', 'MILONGA', 'VALS', 'CANDOMBE') END = 1
                ORDER BY {self.order_by}
                '''

        # orchestra LIKE '%{self.replaceSingleTick(self.orchestra_textbox.text())}%'
        # singers LIKE '%{self.replaceSingleTick(self.singer_textbox.text())}%'
        
        # date > '19{self.mindate_textbox.text() if self.mindate_textbox.text() else '00'}{DATE_ZERO_TIME}' AND 
        # date < '19{self.maxdate_textbox.text() if self.maxdate_textbox.text() else '99'}{DATE_ZERO_TIME}' AND

        connection = DatabaseConnection().get_connection()
        c = connection.cursor()

        tic = time.perf_counter()

        c.execute(query)
        rows = c.fetchall()

        self.table_widget_db.setRowCount(len(rows))
        for row_index, row_data in enumerate(rows):
            for column_index, data in enumerate(row_data):
                table_item = QTableWidgetItem(str(data))
                if column_index == 4:
                    data = self.parseDate(data)
                if column_index == 5 or column_index == 6:  # Center the contents of the second column (index 1)
                    table_item.setTextAlignment(Qt.AlignmentFlag.AlignCenter)
                self.table_widget_db.setItem(row_index, column_index, table_item)

        c.close()


        # if is_orchestra_changed:
        #     self.orchestra_search_results_backup = self.table_widget_db


        toc = time.perf_counter()
        # print(f"Fetchall the tutorial in {toc - tic:0.4f} seconds")
        
        self.color_selected_db_rows()

    def parseDate(self, input):
        date_object = datetime.fromisoformat(input)
        date = date_object.strftime('%Y-%m-%d')
        return date

    def parseYear(self, input):
        date_object = datetime.fromisoformat(input)
        return str(date_object.year)

    # def closeEvent(self, event):
    #     reply = QMessageBox.question(self, 'Confirm Exit',
    #                                  'Are you sure?',
    #                                  QMessageBox.StandardButton.Yes | QMessageBox.StandardButton.No, QMessageBox.StandardButton.No)
    #     if reply == QMessageBox.StandardButton.Yes:
    #         event.accept()
    #     else:
    #         event.ignore()

    # def clickEventHandler(self):
    #     print("Clicked!")

    # def toggleEventHandler(self, checked):
    #     self.button_is_checked = checked
    #     print("Checked?", self.button_is_checked)

    def read_recordings_from_json(self, file_path):
        try:
            with open(file_path, 'r', encoding='utf-8') as file:
                recordings = json.load(file)
                return recordings
        except FileNotFoundError:
            print(f"Error: The file {file_path} does not exist.")
            return []
        except json.JSONDecodeError:
            print(f"Error: The file {file_path} is not a valid JSON file.")
            return []

    def create_and_populate_db(self, recordings):
        conn = DatabaseConnection().get_connection()
        cursor = conn.cursor()
        
        # Create table
        cursor.execute('''CREATE TABLE IF NOT EXISTS recordings (
                            id TEXT PRIMARY KEY,
                            date DATE,
                            music_id INTEGER,
                            title TEXT,
                            style TEXT,
                            orchestra TEXT,
                            singers TEXT,
                            soloist TEXT,
                            director TEXT,
                            composer TEXT,
                            author TEXT,
                            label TEXT,
                            lyrics TEXT,
                            is_mapped NUMERIC,
                            map_date DATETIME,
                            relative_file_path TEXT,
                            audio_source TEXT, 
                            batch_id INTEGER,
                            duplicate_count INTEGER
                        )''')
        
        # Insert recording objects into the table
        for recording in recordings:

            recording_date = recording.get('date')
            if recording_date:
                try:
                    recording_date = datetime.strptime(recording_date, "%Y-%m-%d").date()
                except ValueError:
                    recording_date = None

            cursor.execute('''INSERT OR REPLACE INTO recordings (
                                id, date, music_id, title, style, orchestra, singers,
                                soloist, director, composer, author, label, lyrics, 
                                is_mapped, map_date, relative_file_path, audio_source, batch_id, duplicate_count
                            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)''', (
                                recording.get('id'),
                                recording_date,
                                recording.get('music_id'),
                                str(recording.get('title')).replace("''", "'"),
                                recording.get('style'),
                                str(recording.get('orchestra')).replace("''", "'"),
                                str(recording.get('singer')).replace("''", "'"),
                                str(recording.get('soloist')).replace("''", "'"),
                                str(recording.get('director')).replace("''", "'"),
                                str(recording.get('composer')).replace("''", "'"),
                                str(recording.get('author')).replace("''", "'"),
                                str(recording.get('label')).replace("''", "'"),
                                str(recording.get('lyrics')).replace("''", "'"),
                                0,
                                None,
                                None,
                                None,
                                None,
                                None
                            ))
        
        conn.commit()

    def create_and_populate_singers_table(self):
        # Connect to the SQLite database
        conn = DatabaseConnection().get_connection()
        c = conn.cursor()

        # Create a new table to store singers
        c.execute('''CREATE TABLE IF NOT EXISTS singer_orchestra (
                        id INTEGER PRIMARY KEY,
                        singer TEXT,
                        orchestra TEXT
                    )''')

        # Query the recordings table to get singers and orchestra
        c.execute('''SELECT singers, orchestra FROM recordings WHERE orchestra <> 'None' GROUP BY singers, orchestra HAVING count(*) > 2''')
        records = c.fetchall()

        # Iterate through each record
        for record in records:
            singers, orchestra = record
            if singers:
                for singer in singers.split(' y '):
                    c.execute('''INSERT INTO singer_orchestra (singer, orchestra) VALUES (?, ?)''', (singer, orchestra))

        c = conn.cursor()

        # Remove duplicates based on singer and orchestra pair
        c.execute('''DELETE FROM singer_orchestra 
                    WHERE id NOT IN 
                    (SELECT MIN(id) 
                    FROM singer_orchestra 
                    GROUP BY singer, orchestra)''')

        conn.commit()
        # conn.close()

def main():
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show() 
    DatabaseConnection().close_connection()
    sys.exit(app.exec())

if __name__ == '__main__':
    main()






# ALTER TABLE recordings ADD duplicate_count INTEGER;

# WITH duplicates_table AS (
#     SELECT rec.music_id, dupl.cnt
#     FROM recordings rec
#     JOIN (
#         SELECT orchestra, title, COUNT(title) AS cnt
#         FROM recordings
#         WHERE orchestra <> 'None'
#         GROUP BY orchestra, title
#         HAVING COUNT(title) > 1
#     ) dupl
#     ON dupl.orchestra = rec.orchestra AND dupl.title = rec.title
# )
# UPDATE recordings
# SET duplicate_count = (
#     SELECT cnt
#     FROM duplicates_table
#     WHERE duplicates_table.music_id = recordings.music_id
# )
# WHERE music_id IN (
#     SELECT music_id
#     FROM duplicates_table
# );



# CREATE INDEX date_index ON recordings(date);
# CREATE INDEX title_index ON recordings(title);
# CREATE INDEX orchestra_index ON recordings (orchestra);
# CREATE INDEX date_index ON recordings (date);
# CREATE INDEX orchestra_date_index ON recordings (orchestra, singers, date);





# if(song.tags.get('CATALOGNUMBER') != None):
#     del song.tags['CATALOGNUMBER']
# if(song.tags.get('CONDUCTOR') != None):
#     del song.tags['CONDUCTOR']
# if(song.tags.get('ALBUMSORT') != None):
#     del song.tags['ALBUMSORT']
# if(song.tags.get('MOVEMENTNAME') != None):
#     del song.tags['MOVEMENTNAME']
# if(song.tags.get('DESCRIPTION') != None):
#     del song.tags['DESCRIPTION']
# if(song.tags.get('TIT3') != None):
#     del song.tags['TIT3']
# if(song.tags.get('ISRC') != None):
#     del song.tags['ISRC']
# if(song.tags.get('RATING') != None):
#     del song.tags['RATING']
# if(song.tags.get('CONTENTGROUP') != None):
#     del song.tags['CONTENTGROUP']
# if(song.tags.get('RATING') != None):
#     del song.tags['RATING']
# if(song.tags.get('ADDITIONALINFO') != None):
#     del song.tags['ADDITIONALINFO']
# if(song.tags.get('ALBUM ARTIST') != None):
#     del song.tags['ALBUM ARTIST']
# if(song.tags.get('DISCNUMBER') != None):
#     del song.tags['DISCNUMBER']
# if(song.tags.get('DISCSUBTITLE') != None):
#     del song.tags['DISCSUBTITLE']
# if(song.tags.get('SUBTITLE') != None):
#     del song.tags['SUBTITLE']
# if(song.tags.get('IN_COUNT') != None):
#     del song.tags['IN_COUNT']
# if(song.tags.get('ORIGINALARTIST') != None):
#     del song.tags['ORIGINALARTIST']
# if(song.tags.get('TRACKNUMBER') != None):
#     del song.tags['TRACKNUMBER']
# if(song.tags.get('POPULARIMETER') != None):
#     del song.tags['POPULARIMETER']           
# if(song.tags.get('TIN') != None):
#     del song.tags['TIN']
# if(song.tags.get('COLOR') != None):
#     del song.tags['COLOR']
# if(song.tags.get('ITUNSMPB') != None):
#     del song.tags['ITUNSMPB']
# if(song.tags.get('WORK') != None):
#     del song.tags['WORK']
# if(song.tags.get('X_COUNT') != None):
#     del song.tags['X_COUNT']
# if(song.tags.get('ENCODING') != None):  # MP3, AIF, M4A
#     del song.tags['ENCODING']
# if(song.tags.get('ENCODER') != None):   # FLAC
#     del song.tags['ENCODER']  
# if(song.tags.get('PODCASTDESC') != None):   # M4A
#     del song.tags['PODCASTDESC']
# if(song.tags.get('DESCRIPTION') != None):   # MP3, AIF, FLAC
#     del song.tags['DESCRIPTION']