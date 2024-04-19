import { useAuth } from '@/providers/AuthProvider';
import { Redirect, Stack } from 'expo-router';
import { View } from 'react-native';
import { defaultStyles } from '@/styles';
import { StackScreenWithSearchBar } from '@/constants/layout';

export default function AuthLayout() {
  const { authState } = useAuth();

  if (authState?.authenticated === true) {
    return <Redirect href={'/'} />;
  }

  return (
    <View style={defaultStyles.container}>
      <Stack>
        <Stack.Screen
          name="login"
          options={{
          ...StackScreenWithSearchBar,
          headerShown: false }}
        />
        <Stack.Screen
          name="register"
          options={{
          ...StackScreenWithSearchBar,
          headerShown: false }} 
        />
      </Stack>
    </View>
  );
}