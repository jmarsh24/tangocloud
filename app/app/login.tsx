import React from 'react';
import { StyleSheet, View } from 'react-native';
import { useLogin } from '@/model/session';

export default function Login(): JSX.Element {
  const promptLogin = useLogin();

  return (
    <View style={styles.container}>
      {promptLogin}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});
