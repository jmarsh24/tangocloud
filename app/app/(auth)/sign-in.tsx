import { View, Text, TextInput, StyleSheet, Alert } from 'react-native';
import React, { useState } from 'react';
import Button from '@/components/Button';
import Colors from '@/constants/Colors';
import { Link, Stack } from 'expo-router';
import { useAuth } from '@/providers/AuthProvider';

const SignInScreen = () => {
  const [loginInput, setLogin] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const { login, loading: authLoading } = useAuth(); // Destructuring to get the login function

  async function signInWithLogin() {
  setLoading(true);
  try {
    await login(loginInput, password); // Using login function from useAuth
    // Navigate to your app's main screen or dashboard here if needed
  } catch (error) {
    // Assuming error handling within login function, or you might need to adjust based on your error handling strategy
    Alert.alert("Sign In Error", error.message);
  }
  setLoading(false);
  }

  return (
    <View style={styles.container}>
      <Text style={styles.label}>Email/Username</Text>
      <TextInput
        value={loginInput}
        onChangeText={setLogin}
        placeholder="Email or Username"
        style={styles.input}
      />

      <Text style={styles.label}>Password</Text>
      <TextInput
        value={password}
        onChangeText={setPassword}
        placeholder="Password"
        style={styles.input}
        secureTextEntry
      />

      <Button
        onPress={signInWithLogin}
        disabled={loading || authLoading}
        text={loading ? 'Signing in...' : 'Sign in'}
      />
      <Link href="/sign-up" style={styles.textButton}>
        Don't have an account? Create one.
      </Link>
    </View>
  );

};

const styles = StyleSheet.create({
  container: {
    padding: 20,
    justifyContent: 'center',
    flex: 1,
  },
  label: {
    color: 'gray',
  },
  input: {
    borderWidth: 1,
    borderColor: 'gray',
    padding: 10,
    marginTop: 5,
    marginBottom: 20,
    backgroundColor: 'white',
    borderRadius: 5,
  },
  textButton: {
    alignSelf: 'center',
    fontWeight: 'bold',
    color: Colors.light.tint,
    marginVertical: 10,
  },
});

export default SignInScreen;