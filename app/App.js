import React, { useState, useEffect, useRef } from "react";
import {
  View,
  StyleSheet,
  Button,
  TextInput,
  Text,
  ScrollView,
} from "react-native";
import { Audio } from "expo-av";

export default function App() {
  const [sound, setSound] = useState();
  const [query, setQuery] = useState("");
  const [songs, setSongs] = useState([]);
  const debounceInterval = 1000; // 500 milliseconds
  const debounceTimer = useRef(null); // Using useRef to persist the timer

  async function playSound() {
    console.log("Loading Sound");
    const { sound } = await Audio.Sound.createAsync({
      uri: "https://pub-10ab067adc844f51b24c57dee2e3e3ce.r2.dev/sample_audio_mp3_amarras.mp3",
    });
    setSound(sound);

    console.log("Playing Sound");
    await sound.playAsync();
  }

  useEffect(() => {
    return sound
      ? () => {
          console.log("Unloading Sound");
          sound.unloadAsync();
        }
      : undefined;
  }, [sound]);

  const searchSongs = async () => {
    try {
      const response = await fetch("http://192.168.0.2:3000/graphql", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          query: `
            query {
              searchElRecodoSongs(query: "${query}") {
                id
                title
                orchestra
                singer
                composer
                author
                date
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
      <TextInput
        style={styles.searchBar}
        placeholder="Search for songs"
        value={query}
        autoCorrect={false}
        onChangeText={handleSearchChange}
      />
      <Button title="Play A Pan y Agua" onPress={playSound} />
      <ScrollView style={styles.results}>
        {songs.map((song, index) => (
          <Text key={index} style={styles.songItem}>
            {song.title} by {song.orchestra}
          </Text>
        ))}
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "#F5FCFF",
    paddingTop: 50,
  },
  searchBar: {
    height: 40,
    width: "80%",
    borderColor: "gray",
    borderWidth: 1,
    paddingLeft: 20,
    borderRadius: 50,
  },
  results: {
    marginTop: 20,
    width: "80%",
  },
  songItem: {
    paddingTop: 10,
    paddingBottom: 10,
    borderBottomWidth: 1,
    borderBottomColor: "gray",
  },
});
