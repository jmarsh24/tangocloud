import { Text, Image, View, StyleSheet } from 'react-native';
import { useTheme } from '@react-navigation/native';
import { Link } from 'expo-router';

export default function SingerItem({ singer }) {
  const { colors } = useTheme();

  if (!singer) {
    return null;
  }

  return (
    <Link href={`/singers/${singer.id}`}>
      <View style={styles.container}>
        <Image source={{ uri: singer.photoUrl }} style={styles.image} />
        <Text style={[styles.text, { color: colors.text }]}>{singer.name}</Text>
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
    justifyContent: 'flex-start',
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
