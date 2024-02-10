import React, { useEffect, useRef } from 'react';
import { StyleSheet, View, Text, Image, Animated, Dimensions } from 'react-native';
import { useTheme } from '@react-navigation/native';

export default function trackScreen() {
  const { colors } = useTheme();
  const styles = getStyles(colors); 

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
          source={{ uri: track?.albumArtUrl }}
          style={[styles.albumArt, { 
            width: albumArtSize, 
            height: albumArtSize, 
            borderRadius: albumArtSize / 2 
          }]} 
        />
      </Animated.View>

      <View style={styles.trackInfo}>
        <Text style={styles.title}>{track.title}</Text>
        {track?.orchestra?.name && <Text style={styles.subtitle}>{track.orchestra.name}</Text>}
        {track?.singers?.[0]?.name && <Text style={styles.subtitle}>{track.singers[0].name}</Text>}
        {track?.lyricist?.name && <Text style={styles.subtitle}>{track.lyricist.name}</Text>}
        {track?.composer?.name && <Text style={styles.subtitle}>{track.composer.name}</Text>}
        <View style={styles.row}>
          {track?.genre?.name && <Text style={styles.subtitle}>{track.genre.name}</Text>}
          {track?.recordedDate && <Text style={styles.subtitle}>{track.recordedDate}</Text>}
        </View>
      </View>

      <View style={styles.controls}>
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
      backgroundColor: colors.background, // Use theme color for background
    },
    subtitle: {
      color: colors.text, // Use theme color for text
      fontSize: 12,
    },
    row: {
      display: 'flex',
      gap: 10,
      flexDirection: 'row',
      alignItems: 'center',
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