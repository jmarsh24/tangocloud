import { Text, View } from 'react-native';
import { useTheme } from '@react-navigation/native';
import { Link } from 'expo-router';

export default function SingerItem({ singer }) {
  const { colors } = useTheme();

  if (!singer) {
    return null;
  }

  return (
    <Link href={`/singers/${singer.id}`} style={ { color: colors.text, padding: 10 } }>
      <Text>{singer.name}</Text>
    </Link>
  );
}
