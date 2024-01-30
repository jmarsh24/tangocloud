import React, { useEffect, useRef } from 'react';
import { StyleSheet, View, Text, Image, TouchableOpacity, Animated } from 'react-native';
import { AntDesign } from '@expo/vector-icons';

export default function trackScreen() {
  // Dummy data for demonstration
  const track = {
    title: "Amarras",
    artist: "Juan D'Arienzo - Alberto Echagüe"
  };

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

  return (
    <View style={styles.container}>
      <Animated.View style={[styles.vinyl, { transform: [{ rotate: spin }] }]}>
        <View style={styles.centralHole} />
        <Image source={require('@/assets/images/album_art.jpg')} style={styles.albumArt} />
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
    width: 500,
    height: 500,
    borderRadius: 400,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#0e0e0e'
  },
  centralHole: {
    position: 'absolute',
    width: 20,
    height: 20,
    borderRadius: 10,
    backgroundColor: '#0e0e0e',
    zIndex: 10,
  },
  albumArt: {
    width: 180, // Slightly smaller than the vinyl for the effect
    height: 180,
    borderRadius: 180,
    borderWidth: 5,
    borderColor: 'black',
    opacity: 0.8, // Gives a slight paper-like filter effect
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