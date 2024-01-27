package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
)

type AudioFile struct {
	Name string
	Path string
}

// App struct
type App struct {
	ctx context.Context
}

// NewApp creates a new App application struct
func NewApp() *App {
	return &App{}
}

// startup is called when the app starts. The context is saved
// so we can call the runtime methods
func (a *App) startup(ctx context.Context) {
	a.ctx = ctx
}

func (a *App) PrintLog(message string) {
	fmt.Println(message)
}

func (a *App) ImportCsvFile() {
	filePath := "C:/dev-perso/desktop/tango_matcher/elrecodo.csv"
	FillDatabaseFromCsvFile(filePath)
}

func (a *App) GetAudioFilesInFolder(folderPath string) []AudioFile {
	audioFiles := []AudioFile{}

	fmt.Println(folderPath)

	files, err := os.ReadDir(folderPath)
	if err != nil {
		log.Fatal(err)
	}

	for _, file := range files {
		if (strings.HasSuffix(file.Name(), ".flac")) || (strings.HasSuffix(file.Name(), ".aif")) || (strings.HasSuffix(file.Name(), ".m4a")) || (strings.HasSuffix(file.Name(), ".mp3")) {
			filename := filepath.Join(folderPath, file.Name())

			var a AudioFile
			a.Name = file.Name()
			a.Path = filename

			fmt.Println(file.Name())

			audioFiles = append(audioFiles, a)
		}
	}

	return audioFiles
}

func (a *App) GetFoldersInFolder(folderPath string) []string {
	folderNames := []string{}

	files, err := os.ReadDir(folderPath)
	if err != nil {
		log.Fatal(err)
	}

	for _, file := range files {

		if file.IsDir() {
			folderNames = append(folderNames, file.Name())
		}
	}

	return folderNames
}

func (a *App) GetRecordingsWithFilter(orchestra string, singer string, title string, orderby string) []Recording {
	db, err := connectToSQLite()
	if err != nil {
		log.Fatal(err)
	}

	recordings, _ := getRecordings(db, orchestra, singer, title, orderby, false)

	return recordings
}

func (a *App) GetSongTags() {
	// path := "C:\\Users\\ext.dozen\\Music\\TT-TTT\\song_f.flac"

	cmd := exec.Command("ffmpeg", "-i", "song_f.flac", "-metadata", "title=Track Title", "out.flac")
	cmd.Stderr = os.Stderr
	cmd.Stdout = os.Stdout

	err := cmd.Run()
	if err != nil {
		panic(err)
	}
}

func (a *App) MapSong(musicId uint, audioFilePath string) {
	db, err := connectToSQLite()
	if err != nil {
		log.Fatal(err)
	}

	recording, err := getRecordingByID(db, musicId)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(musicId, recording.Title, audioFilePath)

	sList := strings.Split(audioFilePath, "\\")
	album := sList[len(sList)-2]

	path := strings.Replace(audioFilePath, "TT-TTT", "TT-TTT-tagged", 1)
	pathItems := strings.Split(path, "\\")
	if len(pathItems) > 0 {
		pathItems = pathItems[:len(pathItems)-1]
	}
	outputFolder := strings.Join(pathItems[:], "\\")
	err = os.MkdirAll(outputFolder, os.ModePerm)
	if err != nil {
		log.Println(err)
	}

	fmt.Println(outputFolder)
	//TODO Files are renamed with recording date, title, 2nd artist and style: 19330209 - Milonga sentimental - Ernesto Famá y Angel Ramos - MILONGA

	//TODO test for FLAC AIF, M4A
	//and also for MP3 files. even if there are more tags available in MP3s

	source := "TT" // TT or TTT or Other(Free)

	//TODO store album info in comments somewhere before replacing it !!
	cmdArguments := []string{
		"-i",
		audioFilePath,
		"-metadata",
		"title=" + recording.Title,
		"-metadata",
		"album=" + album,
		"-metadata",
		"artist=" + recording.Singers,
		"-metadata",
		"date=" + recording.Date,
		"-metadata",
		"genre=" + recording.Style,
		"-metadata",
		"album_artist=" + recording.Orchestra,
		"-metadata",
		"composer=Author: " + recording.Author + ", Composer: " + recording.Composer,
		"-metadata",
		"publisher=Source: " + source + ", Label: " + recording.Label,
		"-metadata",
		"comment=" + strconv.Itoa(int(recording.MusicId)),
		"-metadata",
		"lyrics=" + recording.Lyrics,
		path}

	cmd := exec.Command("ffmpeg", cmdArguments...)
	cmd.Stderr = os.Stderr
	cmd.Stdout = os.Stdout

	err = cmd.Run()
	if err != nil {
		panic(err)
	}

}
