import { Text, StyleSheet } from 'react-native';
import { useTheme } from '@react-navigation/native';
import { Link } from 'expo-router';

export default function ComposerItem({ composer }) {
  const { colors } = useTheme();

  if (!composer) {
    return null;
  }

  return (
    <Link href={`/composers/${composer.id}`} style={styles.container}>
      <Text style={[styles.text, { color: colors.text }]}>{composer.name}</Text>
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
    flex: 1,
    fontSize: 16,
    fontWeight: 'bold',
  },
  image: {
    width: 50,
    height: 50,
  },
});
