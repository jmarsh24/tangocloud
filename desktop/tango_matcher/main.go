package main

import (
	"embed"
	"log"

	"github.com/wailsapp/wails/v2"
	"github.com/wailsapp/wails/v2/pkg/options"
	"github.com/wailsapp/wails/v2/pkg/options/assetserver"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

//go:embed all:frontend/dist
var assets embed.FS

func connectToSQLite() (*gorm.DB, error) {
	db, err := gorm.Open(sqlite.Open("tango_manager.db"), &gorm.Config{})
	if err != nil {
		return nil, err
	}

	return db, nil
}

func main() {
	// Create an instance of the app structure
	app := NewApp()

	// Create application with options
	err := wails.Run(&options.App{
		Title:  "TangoMatcher",
		Width:  1024,
		Height: 768,
		AssetServer: &assetserver.Options{
			Assets: assets,
		},
		BackgroundColour: &options.RGBA{R: 27, G: 38, B: 54, A: 1},
		OnStartup:        app.startup,
		Bind: []interface{}{
			app,
		},
	})

	if err != nil {
		println("Error:", err.Error())
	}

	db, err := connectToSQLite()
	if err != nil {
		log.Fatal(err)
	}

	err = db.AutoMigrate(&Recording{})
	if err != nil {
		log.Fatal(err)
	}
}

func first(n int, _ error) int {
	return n
}
