import { Stack } from 'expo-router';
import { View } from 'react-native';
import { defaultStyles } from '@/styles';
import { StackScreenWithSearchBar } from '@/constants/layout';

const Layout = () => {
  return (
    <View style={defaultStyles.container}>
    <Stack>
      <Stack.Screen
        name="index"
        options={{
        ...StackScreenWithSearchBar,
        title: 'Your Library', 
        headerShown: false }} 
      />
    </Stack>
    </View>
  );
}

export default Layout;