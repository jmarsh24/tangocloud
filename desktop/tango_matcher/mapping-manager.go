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

	"github.com/wailsapp/wails/v2/pkg/runtime"
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

			cleanedFileName := strings.Replace(strings.Replace(strings.ToLower(removeAccents(files[i].Name())), "(", " ", -1), "(", " ", -1)
			cleanedFirstWord := strings.Replace(strings.Replace(strings.ToLower(removeAccents(mapping.MatchingWordOne)), "(", " ", -1), "(", " ", -1)
			cleanedSecondWord := strings.Replace(strings.Replace(strings.ToLower(removeAccents(mapping.MatchingWordTwo)), "(", " ", -1), "(", " ", -1)

			if strings.Contains(cleanedFileName, cleanedFirstWord) && strings.Contains(cleanedFileName, cleanedSecondWord) {
				mapping.FilePath = folderPath + "\\" + files[i].Name()
				mapping.FileName = files[i].Name()
			}
		}

		if mapping.FilePath != "" {
			mappings = append(mappings, mapping)
		}
	}

	return mappings //removeDuplicates
}

func (a *App) MapAllRecordings(mappings []Mapping) {
	go func() {
		for i := 0; i < len(mappings); i++ {
			a.MapSong(mappings[i].MusicId, mappings[i].FilePath)
			runtime.EventsEmit(a.ctx, "mapping_done", int(mappings[i].MusicId))
		}

		runtime.EventsEmit(a.ctx, "mappings_all_done", true)
	}()
}

// update recordings set is_mapped = 0, map_date = null, relative_file_path = null, audio_source = null where is_mapped = 1;
func (a *App) MapSong(musicId uint, audioFilePath string) {

	fmt.Println("MapSong: ", musicId, audioFilePath)

	db, err := connectToSQLite()
	if err != nil {
		log.Fatal(err)
	}

	recording, err := getRecordingByID(db, musicId)
	if err != nil {
		log.Fatal(err)
	}

	cmdArguments, newFileName, _ := constructCommand(audioFilePath, recording)
	cmd := exec.Command("ffmpeg", cmdArguments...)
	cmd.Stderr = os.Stderr

	err = cmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	dir, file := filepath.Split(audioFilePath)

	e := os.Rename(audioFilePath, dir+"_DONE_"+removeAccents(file))
	if e != nil {
		log.Fatal(e)
	}

	//if strings.Contains(newFileName, ".flac") {
	//	tagCmdArguments := []string{
	//		newFileName,
	//		"--hideinfo",
	//		"--hidetags",
	//		// "--hidenames",
	//		"--comment",
	//		commentTag,
	//	}
	//
	//	//https://wiki.hydrogenaud.io/index.php?title=Tag_(tagging_software)#Command_line_help
	//	cmdTag := exec.Command("tag", tagCmdArguments...)
	//	// cmdTag.Stderr = os.Stderr
	//	// cmdTag.Stdout = os.Stdout
	//	err = cmdTag.Run()
	//	if err != nil {
	//		log.Fatal(err)
	//	}
	//}

	recording.IsMapped = true
	recording.RelativeFilePath = dir + "_DONE_" + removeAccents(file) + "|" + newFileName
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
	outputFolder := strings.Replace(strings.ToLower(removeAccents(outputBasePath+lastOutputFolder)), " ", "_", -1)
	err := os.MkdirAll(outputFolder, os.ModePerm)
	if err != nil {
		log.Fatal(err)
	}

	return outputFolder
}

func constructCommand(audioFilePath string, recording *Recording) ([]string, string, string) {
	inputItems := strings.Split(audioFilePath, ".")
	extension := inputItems[len(inputItems)-1]
	formattedDate := strings.Replace(recording.Date.Format("2006-01-02"), "-", "", -1)
	outputFolder := getOutputFolder(*recording)

	newFileName := outputFolder + "\\" +
		formattedDate + "_" +
		recording.Title + "_" +
		recording.Singers + "_" +
		recording.Style + "_" +
		strconv.Itoa(int(recording.MusicId)) + "." + extension
	newFileName = strings.Replace(removeAccents(strings.ToLower(newFileName)), " ", "_", -1)

	sList := strings.Split(audioFilePath, "\\")
	album := sList[len(sList)-2]

	oldAlbumTag := getAlbumTag(audioFilePath)

	cmdArguments := []string{
		"-i",
		audioFilePath,
	}

	cmdArguments = append(cmdArguments, "-map", "a:0")
	cmdArguments = append(cmdArguments, "-write_id3v2", "1")

	commentTag := removeAccents(strings.ToLower("Id: ERT-" + strconv.Itoa(int(recording.MusicId)) + " | SOURCE: " + getSourceInfo(audioFilePath) + " | LABEL: " + recording.Label + " | DATE: " + recording.Date.Format("2006-01-02") + " | ORIGINAL_ALBUM: " + oldAlbumTag))

	cmdArguments = append(cmdArguments,
		"-c", "copy",

		"-hide_banner",
		"-loglevel", "error",

		"-metadata", "title="+strings.ToLower(removeAccents(recording.Title)),
		"-metadata", "album="+strings.ToLower(album), // is it good really as album data ??

		"-metadata", "artist="+removeAccents(strings.ToLower(strings.Replace(recording.Singers, " y ", " / ", -1))),
		"-metadata", "date="+recording.Date.Format("2006-01-02"),

		"-metadata", "genre="+strings.ToLower(recording.Style),
		"-metadata", "album_artist="+removeAccents(strings.ToLower(strings.Replace(recording.Orchestra, " y ", " / ", -1))),
		"-metadata", "composer="+removeAccents(strings.ToLower("LYRICIST: "+strings.Replace(recording.Author, " y ", " / ", -1)+" | COMPOSER: "+strings.Replace(recording.Composer, " y ", " / ", -1))),

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
