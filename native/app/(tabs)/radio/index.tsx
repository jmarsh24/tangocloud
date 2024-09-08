import { defaultStyles } from '@/styles'
import { View, Text, StyleSheet } from 'react-native';

const Radio = () => {
  return (
    <View style={[defaultStyles.container, styles.container]}>
      <Text style={styles.text}>
        Radio
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  text: {
    fontSize: 20,
    color: 'white',
  }
});


export default Radio;
