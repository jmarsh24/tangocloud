import React, { useEffect, useRef } from 'react';
import { StyleSheet, View, Text, Image, TouchableOpacity, Animated, Dimensions } from 'react-native';
import { AntDesign } from '@expo/vector-icons';
import { useTheme } from '@react-navigation/native';

export default function trackScreen() {
  const { colors } = useTheme();
  const styles = getStyles(colors); 
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
      <Animated.View style={[styles.vinyl, { 
        width: vinylSize, 
        height: vinylSize, 
        borderRadius: vinylSize / 2, 
        transform: [{ rotate: spin }] 
      }]}>
        <View style={[styles.centralHole, { borderRadius: vinylSize * 0.02 }]} />
        <Image 
          source={require('@/assets/images/album_art.jpg')} 
          style={[styles.albumArt, { 
            width: albumArtSize, 
            height: albumArtSize, 
            borderRadius: albumArtSize / 2 
          }]} 
        />
      </Animated.View>

      <View style={styles.trackInfo}>
        <Text style={styles.title}>{track.title}</Text>
        <Text style={styles.artist}>{track.artist}</Text>
      </View>

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

function getStyles(colors) {
  return StyleSheet.create({
    container: {
      flex: 1,
      justifyContent: 'space-between',
      alignItems: 'center',
      paddingVertical: 100,
      backgroundColor: 'red', // Use theme color for background
    },
    vinyl: {
      justifyContent: 'center',
      alignItems: 'center',
      backgroundColor: '#0e0e0e', // You might want to adapt this color for the theme
    },
    centralHole: {
      position: 'absolute',
      width: 20,
      height: 20,
      backgroundColor: '#0e0e0e', // Same as above
      zIndex: 10,
    },
    albumArt: {
      borderWidth: 5,
      borderColor: 'black' // Same as above
    },
    trackInfo: {
      alignItems: 'center',
    },
    title: {
      fontSize: 24,
      fontWeight: 'bold',
      marginBottom: 4,
      color: colors.text, // Use theme color for text
    },
    artist: {
      fontSize: 18,
      color: colors.text, // Use theme color for text
    },
    controls: {
      flexDirection: 'row',
      justifyContent: 'space-around',
      width: '100%',
      paddingHorizontal: 50,
      paddingBottom: 20,
    },
  });
}