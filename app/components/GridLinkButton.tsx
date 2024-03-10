import React from 'react';
import { Text, StyleSheet, TouchableOpacity } from 'react-native';
import { Link } from 'expo-router';

const GridLinkButton = ({ to, title }) => (
  <Link component={TouchableOpacity} push href={to} style={styles.button}>
    <Text style={styles.buttonText}>{title}</Text>
  </Link>
);

const styles = StyleSheet.create({
  button: {
    margin: 10,
    backgroundColor: '#1DB954',
    padding: 20,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    minWidth: '40%', // Adjust as needed
    minHeight: 100, // Adjust for your content
  },
  buttonText: {
    color: 'white',
    fontWeight: 'bold',
    textAlign: 'center',
  },
});

export default GridLinkButton;