from unidecode import unidecode
from enum import Enum
from datetime import datetime

import time
import pyuca
import sys
import os
import json
import taglib
import sqlite3
from sqlite3 import Connection

from PyQt6.QtCore import Qt

from PyQt6.QtWidgets import (
    QApplication,
    QVBoxLayout,
    QHBoxLayout,
    QGridLayout,
    QWidget,
    QScrollArea,
    QTableWidget,
    QTableWidgetItem,
    QHeaderView,
    QPushButton,
    QLabel,
    QListWidgetItem,
    QListWidget
)

DATE_ZERO_TIME = '-01-01 00:00:00+00:00'
# DEFAULT_PATH = 'C:/Users/ext.dozen/Music/python_app_test'
DEFAULT_PATH = "C:/Users/ext.dozen/Music/TT-TTT-tagged"
DATABASE_JSON_FILENAME = 'el_recodo_db.json'
DATABASE_NAME = 'tangotagger_v1.db'
COLOR_MATCH = Qt.GlobalColor.darkGreen
COLOR_SELECT = "#F58A2C"
ORCHESTRA_LIST = ["Juan D'ARIENZO", "Carlos DI SARLI", "Osvaldo PUGLIESE", "Aníbal TROILO", 
                  "Miguel CALO", "Lucio DEMARE", "Pedro LAURENZ", "Ricardo TANTURI", "Ángel D'AGOSTINO", "Rodolfo BIAGI", 
                  "Francisco CANARO", "Francisco LOMUTO", "Roberto FIRPO", "Julio DE CARO", "Orquesta TÍPICA VICTOR", "Adolfo CARABELLI",
                  "Enrique RODRÍGUEZ", "Alfredo DE ANGELIS", "Osvaldo FRESEDO", "Edgardo DONATO", "Ricardo MALERBA", "Domingo FEDERICO", "José GARCIA",
                  "José BASSO", "Alfredo GOBBI", "Astor PIAZZOLLA", "Horacio SALGÁN", "Enrique FRANCINI", "FRANCINI-PONTIER",
                  "Osmar MADERNA", "Francisco ROTUNDO", "Florindo SASSONE", "Héctor VARELA", 
                  "Juan MAGLIO", "Armando PONTIER", "Rafael CANARO",
                #   "Quinteto PIRINCHO (Francisco Canaro)",
                #   "Ángel VARGAS", "Alberto CASTILLO", "Alberto MARINO", "Alberto MORAN"
                  ]

class MainWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("TaggerV2")

        self.current_directory = os.getcwd()
        self.selected_orchestra = ''
        self.selected_singer = ''
        self.selected_year = ''
        self.labels = ['Id', 'Title', 'Singer', 'Date', 'Genre', 'Count']
        self.collator = pyuca.Collator()
        self.is_mapped = False
        self.showOnlyGoodGenres = True


        self.layout_outer = QHBoxLayout()

        self.layout_outer.addLayout(self.display_layout_fs(), 1)
        self.layout_outer.addLayout(self.display_layout_match(), 1)
        self.layout_outer.addLayout(self.display_layout_database(), 2)
        
        self.setLayout(self.layout_outer)

        self.populate_directory_list()
        self.populate_database_table()

    def display_layout_fs(self):
        self.layout_file = QVBoxLayout()
        
        self.layout_file_menu = QHBoxLayout()
        self.file_menu_button1 = QPushButton("file_menu_button1")
        self.file_menu_button2 = QPushButton("file_menu_button2")
        self.file_menu_button3 = QPushButton("file_menu_button3")
        self.layout_file_menu.addWidget(self.file_menu_button1)
        self.layout_file_menu.addWidget(self.file_menu_button2)
        self.layout_file_menu.addWidget(self.file_menu_button3)

        self.layout_file_content = QVBoxLayout()
        self.db_fs_directories_scrollarea = QScrollArea()
        self.db_fs_directories_scrollarea.setWidgetResizable(True)

        self.list_widget_dirs = QListWidget()
        self.db_fs_directories_scrollarea.setWidget(self.list_widget_dirs)
        self.layout_file_content.addWidget(self.db_fs_directories_scrollarea)

        self.db_fs_files_scrollarea = QScrollArea()
        self.db_fs_files_scrollarea.setWidgetResizable(True)

        self.list_widget_files = QListWidget()
        self.db_fs_files_scrollarea.setWidget(self.list_widget_files)
        self.layout_file_content.addWidget(self.db_fs_files_scrollarea)
        
        self.layout_file.addLayout(self.layout_file_menu)
        self.layout_file.addLayout(self.layout_file_content, 1)
        
        return self.layout_file

    # def display_layout_fs_directories(self):
    #     db_fs_directories_scrollarea = QScrollArea()
    #     db_fs_directories_scrollarea.setWidgetResizable(True)

    #     self.list_widget_dirs = QListWidget()
    #     db_fs_directories_scrollarea.setWidget(self.list_widget_dirs)

    #     return db_fs_directories_scrollarea
    
    # def display_layout_fs_files(self):
    #     db_fs_files_scrollarea = QScrollArea()
    #     db_fs_files_scrollarea.setWidgetResizable(True)

    #     self.list_widget_files = QListWidget()
    #     db_fs_files_scrollarea.setWidget(self.list_widget_files)

    #     return db_fs_files_scrollarea

    def display_layout_match(self):
        self.layout_match = QVBoxLayout()
        self.layout_match_menu = QHBoxLayout()      
        self.match_menu_button1 = QPushButton("tag")
        self.match_menu_button2 = QPushButton("match")
        self.match_menu_button3 = QPushButton("remove")
        self.layout_match_menu.addWidget(self.match_menu_button1)
        self.layout_match_menu.addWidget(self.match_menu_button2)
        self.layout_match_menu.addWidget(self.match_menu_button3)

        self.layout_matchings_content = QVBoxLayout()
        
        self.db_filter_matchings_scrollarea = QScrollArea()
        self.db_filter_matchings_list_widget = QWidget()
        self.layout_matchings_content_vbox = QVBoxLayout()

        for i in range(1,50):
            object = QLabel("matching")
            self.layout_matchings_content_vbox.addWidget(object)

        self.db_filter_matchings_list_widget.setLayout(self.layout_matchings_content_vbox)
        self.db_filter_matchings_scrollarea.setWidget(self.db_filter_matchings_list_widget)
        self.layout_matchings_content.addWidget(self.db_filter_matchings_scrollarea)

        self.layout_match.addLayout(self.layout_match_menu)
        self.layout_match.addLayout(self.layout_matchings_content, 1)

        return self.layout_match
    
    def display_layout_database(self):
        self.layout_database = QVBoxLayout()
        self.layout_database_menu = QHBoxLayout()
        self.database_menu_button1 = QPushButton("database_menu_button1")
        self.database_menu_button2 = QPushButton("database_menu_button2")
        self.database_menu_button3 = QPushButton("database_menu_button3")
        self.database_menu_button4 = QPushButton("database_menu_button4")
        self.database_menu_button5 = QPushButton("database_menu_button5")
        self.layout_database_menu.addWidget(self.database_menu_button1)
        self.layout_database_menu.addWidget(self.database_menu_button2)
        self.layout_database_menu.addWidget(self.database_menu_button3)
        self.layout_database_menu.addWidget(self.database_menu_button4)
        self.layout_database_menu.addWidget(self.database_menu_button5)

        self.layout_database_content = QHBoxLayout()

        self.table_widget_db = QTableWidget()
        self.table_widget_db.horizontalHeader().setSectionResizeMode(QHeaderView.ResizeMode.Stretch)
        self.table_widget_db.setSelectionBehavior(QTableWidget.SelectionBehavior.SelectRows)
        self.table_widget_db.setSelectionMode(QTableWidget.SelectionMode.SingleSelection)
        self.table_widget_db.setMaximumWidth(1200)
        self.table_widget_db.setStyleSheet("QTableWidget::item:selected { background-color: "+COLOR_SELECT+"; color: black; }")
        self.table_widget_db.setColumnCount(len(self.labels))
        self.table_widget_db.setHorizontalHeaderLabels(self.labels)

        self.header = self.table_widget_db.horizontalHeader()
        self.header.setSectionResizeMode(0, QHeaderView.ResizeMode.ResizeToContents)
        self.header.setSectionResizeMode(3, QHeaderView.ResizeMode.ResizeToContents)
        self.header.setSectionResizeMode(4, QHeaderView.ResizeMode.ResizeToContents)
        self.header.setSectionResizeMode(5, QHeaderView.ResizeMode.ResizeToContents)

        self.db_filter_secondartist_scrollarea = QScrollArea()
        self.db_filter_secondartist_list_widget = QWidget()
        self.db_filter_secondartist_list_vbox = QVBoxLayout()

        self.db_filter_secondartist_list_widget.setLayout(self.db_filter_secondartist_list_vbox)
        self.db_filter_secondartist_scrollarea.setWidget(self.db_filter_secondartist_list_widget)

        self.db_filter_firstartist_scrollarea = QScrollArea()
        self.db_filter_firstartist_list_widget = QWidget()
        self.db_filter_firstartist_list_vbox = QVBoxLayout()

        for orchestra in sorted(ORCHESTRA_LIST,  key=self.collator.sort_key):
            self.btn_orchestra = QPushButton(orchestra)
            self.btn_orchestra.clicked.connect(lambda checked, btn_text=orchestra: self.on_orchestra_btn_click(btn_text))
            self.btn_orchestra.setFixedWidth(170)
            self.db_filter_firstartist_list_vbox.addWidget(self.btn_orchestra)

        self.db_filter_firstartist_list_widget.setLayout(self.db_filter_firstartist_list_vbox)
        self.db_filter_firstartist_scrollarea.setWidget(self.db_filter_firstartist_list_widget)

        self.layout_database_content.addWidget(self.db_filter_firstartist_scrollarea)
        self.layout_database_content.addWidget(self.db_filter_secondartist_scrollarea)


        self.layout_database_content.addWidget(self.display_layout_database_filter_year())
        self.layout_database_content.addWidget(self.table_widget_db, 1)

        self.layout_database.addLayout(self.layout_database_menu)
        self.layout_database.addLayout(self.layout_database_content, 1)

        return self.layout_database

    # def display_database(self):
    #     self.table_widget_db = QTableWidget()
    #     self.table_widget_db.horizontalHeader().setSectionResizeMode(QHeaderView.ResizeMode.Stretch)
    #     self.table_widget_db.setSelectionBehavior(QTableWidget.SelectionBehavior.SelectRows)
    #     self.table_widget_db.setSelectionMode(QTableWidget.SelectionMode.SingleSelection)
    #     self.table_widget_db.setMaximumWidth(1200)
    #     self.table_widget_db.setStyleSheet("QTableWidget::item:selected { background-color: "+COLOR_SELECT+"; color: black; }")
    #     # self.table_widget_db.cellClicked.connect(self.handle_database_row_click)

    #     self.table_widget_db.setColumnCount(len(self.labels))
    #     self.table_widget_db.setHorizontalHeaderLabels(self.labels)

    #     header = self.table_widget_db.horizontalHeader()
    #     header.setSectionResizeMode(0, QHeaderView.ResizeMode.ResizeToContents)
    #     header.setSectionResizeMode(3, QHeaderView.ResizeMode.ResizeToContents)
    #     header.setSectionResizeMode(4, QHeaderView.ResizeMode.ResizeToContents)
    #     header.setSectionResizeMode(5, QHeaderView.ResizeMode.ResizeToContents)

    #     # self.table_widget_db.setMinimumHeight(900)
    #     return self.table_widget_db

    def on_orchestra_btn_click(self, orchestra):
        if(self.selected_orchestra == orchestra):
            self.selected_orchestra = None
        else:
            self.selected_orchestra = orchestra.replace('\'', '\'\'')

        self.selected_orchestra_button_text = orchestra
        self.selected_singer = ''        
        self.fill_database_filter_secondartist(orchestra.replace('\'', '\'\''))
        # self.highlight_orchestra_button_by_text(orchestra)

    # def highlight_year_button_by_text(self, text):
    #     for button in self.db_filter_year_list_vbox.children():
    #         if isinstance(button, QPushButton):
    #             if button.text() == text:
    #                 button.setStyleSheet("background-color: #25D072; color: black;")
    #             else:
    #                 button.setStyleSheet("")

    # def highlight_singer_button_by_text(self, text):
    #     for button in self.db_filter_secondartist_list_vbox.children():
    #         if isinstance(button, QPushButton):
    #             if button.text() == text:
    #                 button.setStyleSheet("background-color: #25D072; color: black;")
    #             else:
    #                 button.setStyleSheet("")

    # def highlight_orchestra_button_by_text(self, text):
    #     for button in self.db_filter_firstartist_list_vbox.children():
    #         if isinstance(button, QPushButton):
    #             if button.text() == text:
    #                 button.setStyleSheet("background-color: #25D072; color: black;")
    #             else:
    #                 button.setStyleSheet("")

    def on_year_btn_click(self, year):
        if(self.selected_year == year or year == 'All'):
            self.selected_year = ''
        else:
            self.selected_year = year

        self.selected_year_button_text = year
        self.populate_database_table()
        # self.highlight_year_button_by_text(year)

    def on_singer_btn_click(self, singer):
        if(self.selected_singer == singer or singer == 'All'):
            self.selected_singer = ''
        else:
            self.selected_singer = singer.replace('\'', '\'\'')

        self.selected_singer_button_text = singer
        self.selected_year = ''
        self.display_layout_database_filter_year()

        self.populate_database_table()
        # self.highlight_singer_button_by_text(singer)

    # def display_layout_database_filter_firstartist(self):
    #     db_filter_firstartist_scrollarea = QScrollArea()
    #     db_filter_firstartist_list_widget = QWidget()
    #     self.db_filter_firstartist_list_vbox = QVBoxLayout()

    #     for orchestra in sorted(ORCHESTRA_LIST,  key=self.collator.sort_key):
    #         self.btn_orchestra = QPushButton(orchestra)
    #         self.btn_orchestra.clicked.connect(lambda checked, btn_text=orchestra: self.on_orchestra_btn_click(btn_text))
    #         self.btn_orchestra.setFixedWidth(170)
    #         self.db_filter_firstartist_list_vbox.addWidget(self.btn_orchestra)

    #     db_filter_firstartist_list_widget.setLayout(self.db_filter_firstartist_list_vbox)
    #     db_filter_firstartist_scrollarea.setWidget(db_filter_firstartist_list_widget)
    #     return db_filter_firstartist_scrollarea
    
    # def display_layout_database_filter_secondartist(self):
    #     self.db_filter_secondartist_scrollarea = QScrollArea()
    #     self.db_filter_secondartist_list_widget = QWidget()
    #     self.db_filter_secondartist_list_vbox = QVBoxLayout()

    #     self.db_filter_secondartist_list_widget.setLayout(self.db_filter_secondartist_list_vbox)
    #     self.db_filter_secondartist_scrollarea.setWidget(self.db_filter_secondartist_list_widget)
    #     return self.db_filter_secondartist_scrollarea
    
    def fill_database_filter_secondartist(self, orchestra_name=''):
        conn = DatabaseConnection().get_connection()
        c = conn.cursor()

        c.execute(f"SELECT DISTINCT singer FROM singer_orchestra WHERE orchestra = '{orchestra_name}' AND singer <> 'Instrumental'")
        singers = c.fetchall()

        self.btn_all = QPushButton('All')
        self.btn_all.setFixedWidth(170)
        self.btn_all.clicked.connect(lambda checked, btn_name='All': self.on_singer_btn_click('All'))
        self.db_filter_secondartist_list_vbox.addWidget(self.btn_all)
    
        self.btn_instrumental = QPushButton('Instrumental')
        self.btn_instrumental.setFixedWidth(170)
        self.btn_instrumental.clicked.connect(lambda checked, btn_name='Instrumental': self.on_singer_btn_click('Instrumental'))
        self.db_filter_secondartist_list_vbox.addWidget(self.btn_instrumental)

        singer_names = [tup[0] for tup in singers]
        for singer_name in sorted(singer_names,  key=self.collator.sort_key):
            btn_second_artist_name = QPushButton(singer_name)
            btn_second_artist_name.setFixedWidth(170)
            btn_second_artist_name.clicked.connect(lambda checked, btn_name=singer_name: self.on_singer_btn_click(btn_name))
            self.db_filter_secondartist_list_vbox.addWidget(btn_second_artist_name)

        self.selected_year = ''
        self.display_layout_database_filter_year()

        self.populate_database_table(True)

    def display_layout_database_filter_year(self):
        self.db_filter_year_scrollarea = QScrollArea()
        self.db_filter_year_list_widget = QWidget()
        self.db_filter_year_list_vbox = QVBoxLayout()

        # while self.db_filter_year_list_vbox.count() > 0:
        #     self.db_filter_year_list_vbox.widget(0).setParent(None)

        conn = DatabaseConnection().get_connection()
        cursor = conn.cursor()
        cursor.execute(f'''
                       SELECT DISTINCT strftime('%Y', date) FROM recordings WHERE orchestra = '{self.selected_orchestra}' AND singers LIKE '%{self.selected_singer}%'
                       ''')
        
        # Fetch all distinct years
        distinct_years = sorted([row[0] for row in cursor.fetchall()])
        self.distinct_years_count = len(distinct_years)
        
        if self.distinct_years_count != 0:
            is_first_even = 0
            if(int(distinct_years[0]) % 2 == 0):
                is_first_even = 0
            else:
                is_first_even = 1

            if self.distinct_years_count > 30:
                distinct_years = [year for year in distinct_years if int(year) % 2 == is_first_even]

            self.btn_all = QPushButton('All')
            self.btn_all.setFixedWidth(50)
            self.btn_all.clicked.connect(lambda checked, btn_name='All': self.on_year_btn_click('All'))
            self.db_filter_year_list_vbox.addWidget(self.btn_all)

            for year in distinct_years:
                self.btn_year = QPushButton(year)
                self.btn_year.setFixedWidth(50)
                self.btn_year.clicked.connect(lambda checked, btn_name=year: self.on_year_btn_click(btn_name))
                self.db_filter_year_list_vbox.addWidget(self.btn_year)

        cursor.close()

        self.db_filter_year_list_widget.setLayout(self.db_filter_year_list_vbox)
        self.db_filter_year_scrollarea.setWidget(self.db_filter_year_list_widget)
        return self.db_filter_year_scrollarea

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

    def populate_database_table(self, is_orchestra_changed=False):
        next_year = '2050'
        if(self.selected_year != ''):
            if self.distinct_years_count > 30:
                next_year = str(int(self.selected_year) + 2)
            else:
                next_year = str(int(self.selected_year) + 1)

        query = f'''
            SELECT music_id, title, singers, date, 
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
                date >= date('{self.selected_year if self.selected_year else '1890'}{DATE_ZERO_TIME}') AND 
                date < date('{next_year if next_year else '2050'}{DATE_ZERO_TIME}') AND
                is_mapped = {self.is_mapped} AND
                CASE WHEN {self.showOnlyGoodGenres} then style IN ('TANGO', 'MILONGA', 'VALS') END = 1
            '''
        
        connection = DatabaseConnection().get_connection()
        c = connection.cursor()

        tic = time.perf_counter()

        c.execute(query)
        rows = c.fetchall()

        self.table_widget_db.setRowCount(len(rows))
        for row_index, row_data in enumerate(rows):
            for column_index, data in enumerate(row_data):
                self.table_item = QTableWidgetItem(str(data))
                if column_index == 3:
                    data = self.parseDate(data)
                if column_index == 4 or column_index == 5:
                    self.table_item.setTextAlignment(Qt.AlignmentFlag.AlignCenter)
                self.table_widget_db.setItem(row_index, column_index, self.table_item)

        c.close()

        toc = time.perf_counter()
        # print(f"Fetchall the tutorial in {toc - tic:0.4f} seconds", query)        
        # self.color_selected_db_rows()

    def parseDate(self, input):
        date_object = datetime.fromisoformat(input)
        date = date_object.strftime('%Y-%m-%d')
        return date 
    
    def replaceSingleTick(self, input):
        return input.replace("'", "''")
    
class DatabaseConnection:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(DatabaseConnection, cls).__new__(cls)
            cls._instance._initialize_connection()
        return cls._instance

    def _initialize_connection(self):
        self.connection = sqlite3.connect(DATABASE_NAME)
        self._run_pragma_commands() 

    def get_connection(self) -> Connection:
        return self.connection

    def close_connection(self):
        if self.connection:
            self.connection.close()
            self.__class__._instance = None

    def _run_pragma_commands(self):
        cursor = self.connection.cursor()
        pragmas = [
            "pragma journal_mode = WAL;",
            "pragma synchronous = normal;",
            "pragma temp_store = memory;",
            "pragma mmap_size = 30000000000;",
            "pragma page_size = 32768;",
            "pragma vacuum;",
            "pragma optimize;"
        ]
        for pragma in pragmas:
            cursor.execute(pragma)
        self.connection.commit()

def main():
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show() 
    sys.exit(app.exec())

if __name__ == '__main__':
    main()
