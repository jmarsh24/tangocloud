package main

import (
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
