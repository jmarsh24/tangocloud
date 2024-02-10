import { View, Text, TextInput, StyleSheet, Alert } from 'react-native';
import React, { useState } from 'react';
import Button from '@/components/Button';
import Colors from '@/constants/Colors';
import { Link, Redirect, Stack, router } from 'expo-router';
import { useAuth } from '@/providers/AuthProvider';

const SignUpScreen = () => {
  const { onRegister } = useAuth();
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  async function signUp() {
    setLoading(true);
    try {
      const result = await onRegister(username, email, password);
      if (result.success) {
         Alert.alert("Verification Required", "Please check your email to verify your account before signing in.", [
          { text: "OK", onPress: () => router.replace('/sign-in') }
        ]);
      }
    } catch (error) {
      Alert.alert("Sign Up Failed", error.message);
    } finally {
      setLoading(false);
    }
  }


  return (
    <View style={styles.container}>
      <Stack.Screen options={{ title: 'Sign up' }} />

      <Text style={styles.label}>Username</Text>
      <TextInput
        value={username}
        onChangeText={setUsername}
        placeholder="Jon"
        autoCorrect={false}
        autoComplete='off'
        autoCapitalize='none'
        style={styles.input}
      />

      <Text style={styles.label}>Email</Text>
      <TextInput
        value={email}
        onChangeText={setEmail}
        placeholder="jon@gmail.com"
        autoCorrect={false}
        autoComplete='off'
        autoCapitalize='none'
        style={styles.input}
      />

      <Text style={styles.label}>Password</Text>
      <TextInput
        value={password}
        onChangeText={setPassword}
        placeholder=""
        style={styles.input}
        secureTextEntry
      />

      <Button
        onPress={signUp}
        text={'Create account'}
      />
      <Link href="/sign-in" style={styles.textButton}>
        Sign in
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

export default SignUpScreen;