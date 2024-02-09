import { View } from 'react-native';
import React from 'react';
import Button from '@/components/Button';
import { Redirect } from 'expo-router';
import { useAuth } from '@/providers/AuthProvider';

const index = () => {
  const { authState, onLogout } = useAuth();

  if (authState?.authenticated === false) {
    return <Redirect href={'/sign-in'} />;
  }

  return (
    <View style={{ flex: 1, justifyContent: 'center', padding: 10 }}>
      <Button onPress={onLogout} text="Sign out" />
    </View>
  );
};

export default index; 