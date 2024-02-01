package main

import (
	"log"
	"strings"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Recording struct {
	MusicId uint      `gorm:"primary_key"`
	Id      uuid.UUID `gorm:"type:uuid;uniqueIndex;"`

	Date      time.Time
	ErtNumber string

	Title     string
	Style     string
	Orchestra string
	Singers   string
	Composer  string
	Author    string
	Label     string

	Lyrics string

	Soloist  string
	Director string

	N_Title     string
	N_Orchestra string
	N_Singer    string
	N_Composer  string
	N_Author    string
	N_Soloist   string
	N_Director  string

	Duration   string
	Bpm        uint
	SearchData string

	IsMapped         bool
	MapDate          time.Time
	RelativeFilePath string
	AudioSource      string
}

func createRecording(db *gorm.DB, recording *Recording) error {
	result := db.Create(recording)
	if result.Error != nil {
		return result.Error
	}
	return nil
}

func getRecordingByID(db *gorm.DB, userID uint) (*Recording, error) {
	var recording Recording
	result := db.First(&recording, userID)
	if result.Error != nil {
		return nil, result.Error
	}
	return &recording, nil
}

func getRecordings(db *gorm.DB, orchestra string, singer string, title string, orderby string, ismapped bool, startYear string, endYear string) ([]Recording, error) {
	var recordings []Recording

	filteredResults := db

	if orchestra != "" {
		filteredResults = filteredResults.Where("n_orchestra LIKE ?", "%"+strings.ToLower(orchestra)+"%")
	}
	if singer != "" {
		filteredResults = filteredResults.Where("n_singer LIKE ?", "%"+strings.ToLower(singer)+"%")
	}
	if title != "" {
		filteredResults = filteredResults.Where("n_title LIKE ?", "%"+strings.ToLower(title)+"%")
	}

	filteredResults = filteredResults.Where("is_mapped = ?", ismapped)

	if startYear != "" {
		filteredResults = filteredResults.Where("date >= ?", "19"+startYear+"-01-01 00:00:00")
	}
	if endYear != "" {
		filteredResults = filteredResults.Where("date <= ?", "19"+endYear+"-12-31 00:00:00")
	}

	filteredResults = filteredResults.Where("style IN ?", []string{"TANGO", "MILONGA", "VALS", "CANDOMBE", "RANCHERA"})

	if err := filteredResults.Order(orderby).Find(&recordings).Error; err != nil {
		return recordings, err
	}

	return recordings, nil
}

func updateRecording(db *gorm.DB, recording *Recording) error {
	result := db.Save(recording)
	if result.Error != nil {
		return result.Error
	}
	return nil
}

func deleteRecording(db *gorm.DB, recording *Recording) error {
	result := db.Delete(recording)
	if result.Error != nil {
		return result.Error
	}
	return nil
}

func (a *App) GetRecordingsWithFilter(orchestra string, singer string, title string, orderby string, startDate string, endDate string) []Recording {
	db, err := connectToSQLite()
	if err != nil {
		log.Fatal(err)
	}

	recordings, _ := getRecordings(db, orchestra, singer, title, orderby, false, startDate, endDate)
	return recordings
}
