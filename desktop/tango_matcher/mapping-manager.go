package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"strconv"
	"strings"
)

type Mapping struct {
	MatchingWordOne string
	MatchingWordTwo string
	MusicId         uint
	RecordingTitle  string
	FilePath        string
	FileName        string
}

func (a *App) GetMatchingRecords(folderPath string, orchestra string, singer string, title string, orderby string, startDate string, endDate string) []Mapping {
	mappings := []Mapping{}

	recordings := a.GetRecordingsWithFilter(orchestra, singer, title, orderby, startDate, endDate)
	files, _ := os.ReadDir(folderPath)

	for i := 0; i < len(recordings); i++ {

		mapping := Mapping{}
		mapping.MusicId = recordings[i].MusicId
		mapping.RecordingTitle = recordings[i].Title

		title := recordings[i].Title
		wordOne := longestWord(title)
		mapping.MatchingWordOne = wordOne

		title = strings.Replace(title, wordOne, "", -1)
		wordTwo := longestWord(title)
		mapping.MatchingWordTwo = wordTwo

		for i := 0; i < len(files); i++ {
			if strings.Contains(strings.ToLower(removeAccents(files[i].Name())), strings.ToLower(removeAccents(mapping.MatchingWordOne))) &&
				strings.Contains(strings.ToLower(removeAccents(files[i].Name())), strings.ToLower(removeAccents(mapping.MatchingWordTwo))) {
				mapping.FilePath = folderPath + "\\" + files[i].Name()
				mapping.FileName = files[i].Name()
			}
		}

		if mapping.FilePath != "" {
			mappings = append(mappings, mapping)
		}
	}

	for i := 0; i < len(mappings); i++ {
		fmt.Println(mappings[i].MatchingWordOne, mappings[i].MatchingWordTwo, mappings[i].MusicId, mappings[i].FilePath)
	}

	return mappings
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

	//TODO test for FLAC AIF, M4A
	//and also for MP3 files. even if there are more tags available in MP3s
	//TODO store album info in comments somewhere before replacing it !!
	//TODO flat destination folders
	cmdArguments := constructCommand(audioFilePath, recording)

	cmd := exec.Command("ffmpeg", cmdArguments...)
	cmd.Stderr = os.Stderr
	cmd.Stdout = os.Stdout

	err = cmd.Run()
	if err != nil {
		panic(err)
	}
}

func getOutputFolder(recording Recording) string {
	lastOutputFolder := recording.Orchestra
	if recording.Orchestra == "" {
		lastOutputFolder = recording.Soloist
	}

	outputBasePath := "C:\\Users\\ext.dozen\\Music\\TT-TTT-tagged\\"
	outputFolder := outputBasePath + lastOutputFolder
	err := os.MkdirAll(outputFolder, os.ModePerm)
	if err != nil {
		log.Println(err)
	}

	return outputFolder
}

func constructCommand(audioFilePath string, recording *Recording) []string {
	inputItems := strings.Split(audioFilePath, ".")
	extension := inputItems[len(inputItems)-1]

	outputFolder := getOutputFolder(*recording)
	newFileName := outputFolder + "\\" + strings.Replace(recording.Date.Format("2006-01-02"), "-", "", -1) + " - " + recording.Title + " - " + recording.Singers + " - " + recording.Style + "." + extension

	sList := strings.Split(audioFilePath, "\\")
	album := sList[len(sList)-2]

	cmdArguments := []string{
		"-i",
		audioFilePath,
	}

	if extension == "m4a" {
		//"-map", "a:0",//for m4a
		cmdArguments = append(cmdArguments, "-map", "a:0")
	} else if extension == "aif" {
		//"-write_id3v2", "1", //for aiff
		cmdArguments = append(cmdArguments, "-write_id3v2", "1")
	}

	cmdArguments = append(cmdArguments,
		"-c", "copy",

		"-metadata", "title="+recording.Title,
		"-metadata", "album="+album,

		"-metadata", "artist="+recording.Singers, //author m4a??
		"-metadata", "date="+recording.Date.Format("2006-01-02"), //year m4a??

		"-metadata", "genre="+recording.Style,
		"-metadata", "album_artist="+recording.Orchestra,
		"-metadata", "composer=Author: "+recording.Author+" | Composer: "+recording.Composer,

		// "-metadata", "publisher=Source: " + source + ", Label: " + recording.Label, //maybe doesn't work with m4a

		"-metadata", "comment=Id: ERT-"+strconv.Itoa(int(recording.MusicId))+" | Source: "+getSourceInfo(audioFilePath)+" | Label: "+recording.Label,
		"-metadata", "lyrics="+recording.Lyrics,
		newFileName)

	return cmdArguments
}

func getSourceInfo(audioFilePath string) string {
	source := "FREE"
	if strings.Contains(audioFilePath, "TTT") {
		source = "TTT"
	} else if strings.Contains(audioFilePath, "TT -") {
		source = "TT"
	}

	return source
}
