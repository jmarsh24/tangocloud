package main

import (
	"embed"
	"log"
	"strings"
	"unicode"

	"github.com/wailsapp/wails/v2"
	"github.com/wailsapp/wails/v2/pkg/options"
	"github.com/wailsapp/wails/v2/pkg/options/assetserver"
	"golang.org/x/text/runes"
	"golang.org/x/text/transform"
	"golang.org/x/text/unicode/norm"
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

	//TODO Take this connection from the pool
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

func longestWord(s string) string {
	best, length := "", 0
	for _, word := range strings.Split(s, " ") {
		if len(word) > length {
			best, length = word, len(word)
		}
	}
	return best
}

func removeAccents(s string) string {
	t := transform.Chain(norm.NFD, runes.Remove(runes.In(unicode.Mn)), norm.NFC)
	output, _, e := transform.String(t, s)
	if e != nil {
		log.Fatal(e)
	}
	return output
}

// func removeDuplicates(slice []Mapping) []Mapping {
// 	allKeys := make(map[Mapping]bool)
// 	list := []Mapping{}
// 	for _, item := range slice {
// 		if _, value := allKeys[item]; !value {
// 			allKeys[item] = true
// 			list = append(list, item)
// 		}
// 	}
// 	return list
// }
