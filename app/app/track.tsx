import React, { useEffect, useRef } from 'react';
import { StyleSheet, View, Text, Image, TouchableOpacity, Animated, Dimensions } from 'react-native';
import { AntDesign } from '@expo/vector-icons';


export default function trackScreen() {
  const track = {
    title: "Amarras",
    artist: "Juan D'Arienzo - Alberto Echagüe"
  };

  const screenWidth = Dimensions.get('window').width;
  const spinValue = useRef(new Animated.Value(0)).current;

  // Start the spinning animation
  useEffect(() => {
    Animated.loop(
      Animated.timing(spinValue, {
        toValue: 100,
        duration: 330_000,
        useNativeDriver: true
      })
    ).start();
  }, [spinValue]);

  // Interpolate the animated value to a rotation
  const spin = spinValue.interpolate({
    inputRange: [0, 1],
    outputRange: ['0deg', '360deg']
  });

  const vinylSize = screenWidth * 0.8; // 80% of screen width
  const albumArtSize = vinylSize * 0.36; // 36% of the vinyl size

  return (
    <View style={styles.container}>
      <Animated.View style={[styles.vinyl, { width: vinylSize, height: vinylSize, borderRadius: vinylSize / 2, transform: [{ rotate: spin }] }]}>
        <View style={[styles.centralHole, { borderRadius: vinylSize * 0.02 }]} />
        <Image source={require('@/assets/images/album_art.jpg')} style={[styles.albumArt, { width: albumArtSize, height: albumArtSize, borderRadius: albumArtSize / 2 }]} />
      </Animated.View>
      <Text style={styles.title}>{track.title}</Text>
      <Text style={styles.artist}>{track.artist}</Text>

      <View style={styles.controls}>
        <TouchableOpacity>
          <AntDesign name="hearto" size={24} color="black" />
        </TouchableOpacity>
        <TouchableOpacity>
          <AntDesign name="playcircleo" size={24} color="black" />
        </TouchableOpacity>
        <TouchableOpacity>
          <AntDesign name="plus" size={24} color="black" />
        </TouchableOpacity>
        <TouchableOpacity>
          <AntDesign name="sharealt" size={24} color="black" />
        </TouchableOpacity>
        <TouchableOpacity>
          <AntDesign name="ellipsis1" size={24} color="black" />
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
    vinyl: {
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#0e0e0e',
  },
  centralHole: {
    position: 'absolute',
    width: 20,
    height: 20,
    backgroundColor: '#0e0e0e',
    zIndex: 10,
  },
  albumArt: {
    borderWidth: 5,
    borderColor: 'black'
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 4,
  },
  artist: {
    fontSize: 18,
    color: 'gray',
    marginBottom: 20,
  },
  controls: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    width: '100%',
    paddingHorizontal: 50,
  },
});