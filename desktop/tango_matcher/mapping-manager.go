package main

import (
	"fmt"
	"io/fs"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"
	"time"
)

type Mapping struct {
	MatchingWordOne string
	MatchingWordTwo string
	MusicId         uint
	RecordingTitle  string
	FilePath        string
	FileName        string
}

func (a *App) MapAllMatchingRecordings(mappings []Mapping) {
	for i := 0; i < len(mappings); i++ {
		fmt.Println("TO BE MAPPED", mappings[i].MusicId, mappings[i].FilePath)
		a.MapSong(mappings[i].MusicId, mappings[i].FilePath)
	}
}

func (a *App) GetMatchingRecords(folderPath string, orchestra string, singer string, title string, orderby string, startDate string, endDate string) []Mapping {
	mappings := []Mapping{}

	recordings := a.GetRecordingsWithFilter(orchestra, singer, title, orderby, startDate, endDate)
	files, _ := os.ReadDir(folderPath)

	unAssignedFiles := []fs.DirEntry{}

	for i := 0; i < len(files); i++ {
		if !strings.Contains(files[i].Name(), "_DONE_") {
			unAssignedFiles = append(unAssignedFiles, files[i])
		}
	}

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

		for i := 0; i < len(unAssignedFiles); i++ {

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

	// for i := 0; i < len(mappings); i++ {
	// 	fmt.Println(mappings[i].MatchingWordOne, mappings[i].MatchingWordTwo, mappings[i].MusicId, mappings[i].FilePath)
	// }

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

	cmdArguments, newFileName, commentTag := constructCommand(audioFilePath, recording)
	cmd := exec.Command("ffmpeg", cmdArguments...)
	cmd.Stderr = os.Stderr
	cmd.Stdout = os.Stdout

	err = cmd.Run()
	if err != nil {
		panic(err)
	}

	dir, file := filepath.Split(audioFilePath)
	// fmt.Println(dir, file)

	e := os.Rename(audioFilePath, dir+"_DONE_"+file)
	if e != nil {
		log.Fatal(e)
	}

	if strings.Contains(newFileName, ".flac") {
		tagCmdArguments := []string{
			newFileName,
			"--comment",
			commentTag,
		}

		cmdTag := exec.Command("tag", tagCmdArguments...)
		cmdTag.Stderr = os.Stderr
		cmdTag.Stdout = os.Stdout
		err = cmdTag.Run()
		if err != nil {
			panic(err)
		}
	}

	recording.IsMapped = true
	recording.RelativeFilePath = dir + "_DONE_" + file + "|" + newFileName
	recording.MapDate = time.Now()
	recording.AudioSource = getSourceInfo(audioFilePath)
	err = updateRecording(db, recording)
	if e != nil {
		log.Fatal(e)
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

func constructCommand(audioFilePath string, recording *Recording) ([]string, string, string) {
	inputItems := strings.Split(audioFilePath, ".")
	extension := inputItems[len(inputItems)-1]
	formattedDate := strings.Replace(recording.Date.Format("2006-01-02"), "-", "", -1)
	outputFolder := getOutputFolder(*recording)

	newFileName := outputFolder + "\\" + formattedDate + " - " + recording.Title + " - " + recording.Singers + " - " + recording.Style + "." + extension
	newFileName = removeAccents(strings.ToLower(newFileName))

	sList := strings.Split(audioFilePath, "\\")
	album := sList[len(sList)-2]

	oldAlbumTag := getAlbumTag(audioFilePath)

	cmdArguments := []string{
		"-i",
		audioFilePath,
	}

	// if extension == "m4a" {
	cmdArguments = append(cmdArguments, "-map", "a:0")
	// }
	// else if extension == "aif" {
	cmdArguments = append(cmdArguments, "-write_id3v2", "1")
	// cmdArguments = append(cmdArguments, "-id3v2_version", "3")
	// }

	commentTag := strings.ToLower("Id: ERT-" + strconv.Itoa(int(recording.MusicId)) + " | Source: " + getSourceInfo(audioFilePath) + " | Label: " + recording.Label + " | Date: " + recording.Date.Format("2006-01-02") + " | OriginalAlbum: " + oldAlbumTag)

	//TODO everyting lowercase

	cmdArguments = append(cmdArguments,
		"-c", "copy",

		"-metadata", "title="+strings.ToLower(recording.Title),
		"-metadata", "album="+strings.ToLower(album), // is it good really as album data

		"-metadata", "artist="+strings.ToLower(recording.Singers),
		"-metadata", "date="+recording.Date.Format("2006-01-02"),

		"-metadata", "genre="+strings.ToLower(recording.Style),
		"-metadata", "album_artist="+strings.ToLower(recording.Orchestra),
		"-metadata", "composer=author: "+strings.ToLower(recording.Author)+" | composer: "+strings.ToLower(recording.Composer),

		"-metadata", "publisher=",
		"-metadata", "color=",
		"-metadata", "creator=",
		"-metadata", "description="+commentTag, //TO TRY: maybe for Justin's M4A

		"-metadata", "Comment="+commentTag,
		"-metadata", "TIT3="+commentTag,
		"-metadata", "Lyrics="+recording.Lyrics,
		newFileName)

	return cmdArguments, newFileName, commentTag
}

// TODO now they are all FREE....
func getSourceInfo(audioFilePath string) string {
	temp := strings.Replace(audioFilePath, "TT-TTT", "", 1)
	source := "FREE"
	if strings.Contains(temp, "TTT") {
		source = "TTT"
	} else if strings.Contains(temp, "TT -") {
		source = "TT"
	}

	return source
}

func getAlbumTag(filePath string) string {
	cmdArguments := []string{filePath, "-show_entries", "format_tags=album", "-of", "compact=p=0:nk=1", "-v", "0"}
	cmd := exec.Command("ffprobe", cmdArguments...)

	out, err := cmd.Output()
	if err != nil {
		log.Fatal(err)
	}

	return string(out[:])
}
