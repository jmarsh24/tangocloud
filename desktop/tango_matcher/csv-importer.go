package main

import (
	"encoding/csv"
	"io"
	"log"
	"os"
	"strconv"
	"time"

	"github.com/google/uuid"
)

func first(n int, _ error) int {
	return n
}

func (a *App) ImportCsvFile() {
	filePath := "elrecodo.csv"
	FillDatabaseFromCsvFile(filePath)
}

func FillDatabaseFromCsvFile(csvFilePath string) {

	file, err := os.Open(csvFilePath)

	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	db, err := connectToSQLite()
	if err != nil {
		log.Fatal(err)
	}

	reader := csv.NewReader(file)

	for {
		var recording Recording

		lineItems, err := reader.Read()
		if err == io.EOF {
			break
		}

		//recordingLine := scanner.Text()
		//fmt.Println(lineItems)
		//lineItems := strings.Split(recordingLine, ",")

		recording.Id = uuid.MustParse(lineItems[0])

		format := "2006-01-02"
		date, _ := time.Parse(format, lineItems[1])

		recording.Date = date
		recording.ErtNumber = lineItems[2]
		recording.MusicId = uint(first(strconv.Atoi(lineItems[3])))

		recording.Title = lineItems[4]
		recording.Style = lineItems[5]
		recording.Orchestra = lineItems[6]
		recording.Singers = lineItems[7]
		recording.Composer = lineItems[8]
		recording.Author = lineItems[9]
		recording.Label = lineItems[10]

		recording.Lyrics = lineItems[11]

		recording.Soloist = lineItems[22]
		recording.Director = lineItems[23]

		recording.N_Title = lineItems[12]
		recording.N_Orchestra = lineItems[13]
		recording.N_Singer = lineItems[14]
		recording.N_Composer = lineItems[15]
		recording.N_Author = lineItems[16]
		recording.N_Soloist = lineItems[24]
		recording.N_Director = lineItems[25]

		recording.SearchData = lineItems[17]

		// recording.synced_at = lineItems[18]
		// recording.page_updated_at = lineItems[19]
		// recording.created_at = lineItems[20]
		// recording.updated_at = lineItems[21]

		//log.Println(recording.MusicId)

		err = createRecording(db, &recording)
		if err != nil {
			log.Println(err)
			log.Fatal(err)
		}
	}

	log.Println("COMPLETED")
}
