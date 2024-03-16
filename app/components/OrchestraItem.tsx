import { Text } from 'react-native';
import { useTheme } from '@react-navigation/native';
import { Link } from 'expo-router';

export default function OrchestraItem({ orchestra }) {
  const { colors } = useTheme();

  if (!orchestra) {
    return null;
  }

  return (
    <Link href={`/orchestras/${orchestra.id}`} style={ { color: colors.text, padding: 10 } }>
      <Text>{orchestra.name}</Text>
    </Link>
  );
}
