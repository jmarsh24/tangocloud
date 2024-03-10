import { Text, View } from 'react-native';
import { useTheme } from '@react-navigation/native';
import { Link } from 'expo-router';

export default function LyricistItem({ lyricist }) {
  const { colors } = useTheme();

  if (!lyricist) {
    return null;
  }

  return (
    <Link href={`/lyricists/${lyricist.id}`} style={ { color: colors.text, padding: 10 } }>
      <Text>{lyricist.name}</Text>
    </Link>
  );
}
