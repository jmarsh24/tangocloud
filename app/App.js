import React, { useState, useEffect, useRef } from "react";
import {
  View,
  StyleSheet,
  TextInput,
  Text,
  ScrollView,
  Pressable,
} from "react-native";
import { Audio } from "expo-av";

export default function App() {
  const [sound, setSound] = useState();
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentTrackIndex, setCurrentTrackIndex] = useState(0);
  const [query, setQuery] = useState("");
  const [songs, setSongs] = useState([]);
  const debounceInterval = 500;
  const debounceTimer = useRef(null);
  const audioLinks = [
    "https://pub-10ab067adc844f51b24c57dee2e3e3ce.r2.dev/sample_audio_mp3_amarras.mp3",
    "https://pub-10ab067adc844f51b24c57dee2e3e3ce.r2.dev/029_-_Nunca_tuvo_novio_20240126123537.mp3",
  ];

  async function loadSound(trackIndex) {
    if (sound) {
      await sound.unloadAsync();
    }
    console.log("Loading Sound");
    const { sound: newSound } = await Audio.Sound.createAsync({
      uri: audioLinks[trackIndex],
    });
    setSound(newSound);
    if (isPlaying) {
      await newSound.playAsync();
    }
  }

  useEffect(() => {
    loadSound(currentTrackIndex);
    return sound
      ? () => {
          console.log("Unloading Sound");
          sound.unloadAsync();
        }
      : undefined;
  }, [currentTrackIndex]);

  const togglePlayback = async () => {
    if (!sound) {
      return;
    }
    if (isPlaying) {
      console.log("Pausing Sound");
      await sound.pauseAsync();
    } else {
      console.log("Playing Sound");
      await sound.playAsync();
    }
    setIsPlaying(!isPlaying);
  };

  const playNext = () => {
    let nextIndex = currentTrackIndex + 1;
    if (nextIndex >= audioLinks.length) {
      nextIndex = 0;
    }
    setCurrentTrackIndex(nextIndex);
  };

  const playPrevious = () => {
    let previousIndex = currentTrackIndex - 1;
    if (previousIndex < 0) {
      previousIndex = audioLinks.length - 1;
    }
    setCurrentTrackIndex(previousIndex);
  };

  const searchSongs = async () => {
    const searchQuery = query || "*";
    try {
      const response = await fetch("https://api.tangocloud.app/graphql", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          query: `
          query {
            searchElRecodoSongs(query: "${searchQuery}") {
              id
              title
              orchestra
              singer
              composer
              author
              date
              style
            }
          }
        `,
        }),
      });

      const json = await response.json();
      setSongs(json.data.searchElRecodoSongs);
    } catch (error) {
      console.error("Error fetching songs:", error);
    }
  };

  const handleSearchChange = (text) => {
    setQuery(text);
    if (debounceTimer.current) clearTimeout(debounceTimer.current);
    debounceTimer.current = setTimeout(() => {
      searchSongs();
    }, debounceInterval);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.logo}>
        <Text style={{ color: "#007aff" }}>Tango</Text>Cloud
      </Text>
      <TextInput
        style={styles.searchBar}
        placeholder="Search for songs"
        value={query}
        autoCorrect={false}
        onChangeText={handleSearchChange}
      />
      <View style={styles.playbackMenu}>
        <View style={styles.buttonContainer}>
          <Pressable style={styles.button} onPress={playPrevious}>
            <Text style={styles.buttonText}>Previous</Text>
          </Pressable>
          <Pressable style={styles.button} onPress={togglePlayback}>
            <Text style={styles.buttonText}>
              {isPlaying ? "Pause" : "Play"}
            </Text>
          </Pressable>
          <Pressable style={styles.button} onPress={playNext}>
            <Text style={styles.buttonText}>Next</Text>
          </Pressable>
        </View>
      </View>
      <ScrollView style={styles.results}>
        {songs.map((song, index) => (
          <View key={index} style={styles.songCard}>
            <Text style={styles.songTitle}>{song.title}</Text>
            <Text style={styles.songDetails}>
              {song.orchestra} - {song.singer}
            </Text>
            <Text style={styles.songSubDetails}>
              {song.style} - {song.date}
            </Text>
          </View>
        ))}
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "flex-start",
    alignItems: "center",
    backgroundColor: "#121212",
    paddingTop: 50,
    paddingBottom: 60,
  },
  searchBar: {
    height: 40,
    width: "90%",
    backgroundColor: "#1e1e1e",
    borderColor: "#1e1e1e",
    borderWidth: 1,
    paddingLeft: 20,
    borderRadius: 30,
    paddingRight: 20,
    fontSize: 16,
    color: "#fff",
    marginBottom: 20,
  },
  button: {
    padding: 10,
    backgroundColor: "#007aff",
    alignItems: "center",
    justifyContent: "center",
    borderRadius: 5,
  },
  buttonText: {
    color: "white",
    fontSize: 16,
    fontWeight: "bold",
  },
  buttonContainer: {
    flexDirection: "row",
    justifyContent: "space-around",
    width: 300,
  },
  playbackMenu: {
    position: "absolute",
    bottom: 0,
    flexDirection: "row",
    justifyContent: "space-around",
    alignItems: "center",
    width: "100%",
    borderTopColor: "#282828",
    borderTopWidth: 1,
    paddingTop: 20,
    backgroundColor: "#181818",
    paddingVertical: 20,
    zIndex: 1,
  },
  results: {
    flex: 1,
    width: "100%",
    paddingLeft: 20,
    paddingRight: 20,
  },
  songCard: {
    backgroundColor: "#1e1e1e",
    display: "flex",
    flexDirection: "column",
    gap: 5,
    paddingTop: 20,
    paddingBottom: 20,
    paddingLeft: 10,
    paddingRight: 10,
    borderRadius: 8,
    marginBottom: 10,
    marginTop: 10,
  },
  songTitle: {
    fontWeight: "bold",
    fontSize: 16,
    color: "#fff",
    marginLeft: 10,
  },
  songDetails: {
    fontSize: 14,
    color: "gray",
    marginLeft: 10,
  },
  songSubDetails: {
    fontSize: 12,
    color: "gray",
    marginLeft: 10,
  },
  logo: {
    fontSize: 24,
    color: "#fff",
    fontWeight: "bold",
    marginBottom: 20,
  },
});
