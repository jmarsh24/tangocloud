import React from 'react';
import { View, Text, Image, StyleSheet } from 'react-native';

interface OrchestraItemProps {
  name: string;
  imageUrl: string;
}

const OrchestraItem: React.FC<OrchestraItemProps> = ({ name, imageUrl }) => {
  return (
    <View style={styles.container}>
      <Image source={{ uri: imageUrl }} style={styles.image} />
      <Text style={styles.name}>{name}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'column',
    alignItems: 'center',
    gap: 10,
  },
  image: {
    width: 60,
    height: 60,
    borderRadius: 30
  },
  name: {
    fontSize: 16,
    color: 'white',
    textAlign: 'center',
    flexWrap: 'wrap',
    width: 80,
  },
});

export default OrchestraItem;
