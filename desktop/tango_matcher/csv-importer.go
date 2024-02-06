package main

import (
	"encoding/csv"
	"fmt"
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

func (a *App) CheckById() {
	db, err := connectToSQLite()
	if err != nil {
		log.Fatal(err)
	}

	rec, err := getRecordingByID(db, uint(6647))

	if err != nil {
		log.Panicln(err)
	}

	if rec != nil {
		fmt.Println("ALREADY DONE => ", rec.MusicId, rec.Orchestra, rec.Soloist, rec.Title)
	}
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

		err = createRecording(db, &recording)
		if err != nil {
			log.Fatal(err)
		}
	}

	log.Println("COMPLETED")
}
