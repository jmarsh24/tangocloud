import { Text, View } from 'react-native';
import { useTheme } from '@react-navigation/native';
import { Link } from 'expo-router';

export default function ComposerItem({ composer }) {
  const { colors } = useTheme();

  if (!composer) {
    return null;
  }

  return (
    <Link href={`/composers/${composer.id}`} style={ { color: colors.text, padding: 10 } }>
      <Text>{composer.name}</Text>
    </Link>
  );
}
