import { TouchableOpacity, Image } from 'react-native';
import { Text, View, StyleSheet } from 'react-native';
import { useTheme } from '@react-navigation/native';

const orchestras = [
  'Carlos Di Sarli',
  'Osvaldo Pugliese',
  'Anibal Troilo',
  'Rodolfo Biagi',
  'Juan DArienzo'
];

const images = {
  'Carlos Di Sarli': require('@/assets/images/carlos_di_sarli.jpg'),
  'Osvaldo Pugliese': require('@/assets/images/osvaldo_pugliese.jpg'),
  'Anibal Troilo': require('@/assets/images/anibal_troilo.jpg'),
  'Rodolfo Biagi': require('@/assets/images/rodolfo_biagi.jpg'),
  'Juan DArienzo': require('@/assets/images/juan_darienzo.jpg'),
};

export default function HomeScreen() {
  const { colors } = useTheme(); // Extract colors from the theme

  return (
    <View style={[styles.container, { backgroundColor: colors.background }]}>
      <Text style={[styles.headerText, { color: colors.text }]}>
        The people who are crazy enough to think they can change the world are the ones who do.
      </Text>
      {orchestras.map((orchestra, index) => (
        <TouchableOpacity key={index} style={[styles.buttonStyle, { backgroundColor: colors.card }]}>
          <Image source={images[orchestra]} style={styles.songAlbumArt} />
          <Text style={[styles.buttonText, { color: colors.text }]}> 
            {orchestra}
          </Text>
        </TouchableOpacity>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
   container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 10,
  },
  buttonStyle: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#DDDDDD',
    padding: 10,
    marginVertical: 5,
    borderRadius: 5,
    width: '90%', // Adjust as needed
  },
  songAlbumArt: {
    width: 50,
    height: 50,
    marginRight: 10, // Space between image and text
  },
  buttonText: {
    fontWeight: 'bold',
    fontSize: 16, // Adjust as needed
  },
  headerText: {
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
    paddingHorizontal: 20,
    marginBottom: 20, // Space between header and buttons
  },
});