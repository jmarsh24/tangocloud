import React from 'react';
import { Text, Image, StyleSheet, View } from 'react-native';
import { useTheme } from '@react-navigation/native';
import { Link } from 'expo-router';

export default function OrchestraItem({ orchestra }) {
  const { colors } = useTheme();

  if (!orchestra) {
    return null;
  }

  return (
    <Link push href={`/search/orchestras/${orchestra.id}`}>
      <View style={styles.container}>
        <Image source={{ uri: orchestra.photoUrl }} style={styles.image} />
        <Text style={[styles.text, { color: colors.text }]}>{orchestra.name}</Text>
      </View>
    </Link>
  );
}

const styles = StyleSheet.create({
  container: {
    padding: 10,
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 20,
  },
  text: {
    flexShrink: 1,
    fontSize: 16,
    fontWeight: 'bold',
  },
  image: {
    width: 50,
    height: 50,
  },
});
