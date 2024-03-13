import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Link } from 'expo-router';
import { useTheme } from '@react-navigation/native';
import { SafeAreaView } from 'react-native-safe-area-context';

const BrowseScreen = () => {
  const { colors } = useTheme();
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.row}>
        <Link style={styles.link} push href="/orchestras">
          <View style={[styles.button, { borderColor: colors.primary }]}>
            <Text style={[styles.buttonText, { color: colors.text }]}>Orchestras</Text>
          </View>
        </Link>
        <Link style={styles.link} push href="/singers">
          <View style={[styles.button, { borderColor: colors.primary }]}>
            <Text style={[styles.buttonText, { color: colors.text }]}>Singers</Text>
          </View>
        </Link>
      </View>
      <View style={styles.row}>
        <Link style={styles.link} push href="/composers">
          <View style={[styles.button, { borderColor: colors.primary }]}>
            <Text style={[styles.buttonText, { color: colors.text }]}>Composers</Text>
          </View>
        </Link>
        <Link style={styles.link} push href="/lyricists">
          <View style={[styles.button, { borderColor: colors.primary }]}>
            <Text style={[styles.buttonText, { color: colors.text }]}>Lyricists</Text>
          </View>
        </Link>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    gap: 20,  
    justifyContent: 'flex-start',
    padding: 20,
  },
  row: {
    gap: 20, 
    flexDirection: 'row',
    justifyContent: 'space-around', 
  },
  link: {
    flex: 1,
    justifyContent: 'center',
    alignContent: 'center',
    borderWidth: 2,
    borderRadius: 20,
  },
  button: {
    paddingVertical: 20,
    paddingHorizontal: 10,
    borderRadius: 20,
    alignItems: 'center',
    justifyContent: 'center',
  },
  buttonText: {
    fontWeight: 'bold',
  },
});

export default BrowseScreen;
