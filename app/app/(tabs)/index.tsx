import { Text, View, StyleSheet } from 'react-native';
import { useTheme } from '@react-navigation/native';

export default function Page() {
  const { colors } = useTheme();
  
  return (
    <View style={styles.container}>
       <Text style={[styles.headerText, { color: colors.text }]}>
        The people who are crazy enough to think they can change the world are the ones who do.
      </Text>
    </View>
  )
}

const styles = StyleSheet.create({
   container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 10,
  },
  headerText: {
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
    paddingHorizontal: 20,
    marginBottom: 20,
  },
});