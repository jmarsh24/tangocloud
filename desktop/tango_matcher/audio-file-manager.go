package main

import (
	"fmt"
	"gorm.io/gorm"
	"io/fs"
	"log"
	"os"
	"path/filepath"
	"strings"
)

type AudioFile struct {
	Name string
	Path string
}

type MusicPath struct {
	PathId              uint `gorm:"primary_key"`
	Path                string
	ParentPath          string
	NotEmptyFolderCount string
	AudioFileCount      string
}

func createMusicPath(db *gorm.DB, musicPath *MusicPath) error {
	result := db.Create(musicPath)
	if result.Error != nil {
		return result.Error
	}
	return nil
}

func (a *App) CreateDirectoryTree(basePath string) {
	baseFileSystem := os.DirFS(basePath)

	fs.WalkDir(baseFileSystem, ".", func(p string, d fs.DirEntry, err error) error {

		dir := filepath.Dir(p)
		base := filepath.Base(p)
		if !strings.Contains(base, "_DONE_") {
			fmt.Println(dir, base)
		}

		return nil
	})
}

func (a *App) GetAudioFilesInFolder(folderPath string) []AudioFile {
	audioFiles := []AudioFile{}

	files, err := os.ReadDir(folderPath)
	if err != nil {
		log.Fatal(err)
	}

	unAssignedFiles := []fs.DirEntry{}
	for i := 0; i < len(files); i++ {
		if !strings.Contains(files[i].Name(), "_DONE_") {
			unAssignedFiles = append(unAssignedFiles, files[i])
		}
	}

	for _, file := range unAssignedFiles {
		if (strings.HasSuffix(file.Name(), ".flac")) || (strings.HasSuffix(file.Name(), ".aif")) || (strings.HasSuffix(file.Name(), ".aiff")) || (strings.HasSuffix(file.Name(), ".m4a")) || (strings.HasSuffix(file.Name(), ".mp3")) {
			filename := filepath.Join(folderPath, file.Name())

			var a AudioFile
			a.Name = file.Name()
			a.Path = filename

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
