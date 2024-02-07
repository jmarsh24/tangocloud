package main

import (
	"golang.org/x/text/runes"
	"golang.org/x/text/transform"
	"golang.org/x/text/unicode/norm"
	"log"
	"strings"
	"unicode"
)

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
