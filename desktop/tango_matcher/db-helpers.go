package main

import (
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"log"
)

func connectToSQLite() (*gorm.DB, error) {
	db, err := gorm.Open(sqlite.Open("tango_manager.db"), &gorm.Config{})
	if err != nil {
		return nil, err
	}

	return db, nil
}

func autoMigrate() {
	db, err := connectToSQLite()
	if err != nil {
		log.Fatal(err)
	}

	err = db.AutoMigrate(&Recording{})
	if err != nil {

		log.Fatal(err)
	}

	err = db.AutoMigrate(&MusicPath{})
	if err != nil {
		log.Fatal(err)
	}
}
