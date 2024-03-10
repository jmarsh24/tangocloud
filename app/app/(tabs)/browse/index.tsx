import React from 'react';
import { View } from 'react-native';
import { Stack, Link } from 'expo-router';

const BrowseScreen = () => {
  return (
    <View>
      <Link push href="/orchestras">Orchestras</Link>
      <Link push href="/singers">Singers</Link>
      <Link push href="/composers">Composers</Link>
      <Link push href="/lyricists">Lyricists</Link>
    </View>
  );
}

export default BrowseScreen;