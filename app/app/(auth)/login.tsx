import { View, Text, TextInput, StyleSheet, Alert, KeyboardAvoidingView, Platform, useColorScheme } from 'react-native';
import React, { useState } from 'react';
import Button from '@/components/Button';
import Colors from '@/constants/Colors';
import { Link } from 'expo-router';
import { useAuth } from '@/providers/AuthProvider';

const LoginScreen = () => {
  const colorScheme = useColorScheme();
  const [login, setLogin] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const { onLogin } = useAuth();

  async function signIn() {
    setLoading(true);
    try {
      await onLogin(login, password);
    } catch (error) {
      Alert.alert("Login Failed", error.message);
    } finally {
      setLoading(false);
    }
  }

  const dynamicStyles = StyleSheet.create({
    container: { 
      padding: 20,
      justifyContent: 'center',
      flex: 1,
      backgroundColor: colorScheme === 'dark' ? Colors.dark.background : Colors.light.background,
    },
    label: {
      color: colorScheme === 'dark' ? Colors.dark.text : Colors.light.text,
    },
    input: {
      borderWidth: 1,
      borderColor: colorScheme === 'dark' ? Colors.dark.inputBorder : Colors.light.inputBorder,
      padding: 10,
      marginTop: 5,
      marginBottom: 20,
      backgroundColor: colorScheme === 'dark' ? Colors.dark.inputBackground : Colors.light.inputBackground,
      borderRadius: 5,
      fontSize: 18,
      color: colorScheme === 'dark' ? Colors.dark.text : Colors.light.text,
    },
    textButton: {
      alignSelf: 'center',
      fontWeight: 'bold',
      color: colorScheme === 'dark' ? Colors.dark.textSecondary : Colors.light.textSecondary,
      marginVertical: 10,
    },
  });

  return (
    <View style={{ flex: 1 }}> 
      <KeyboardAvoidingView
        style={{ flex: 1 }}
        behavior={Platform.OS === "ios" ? "padding" : "height"}
      >
        <View style={dynamicStyles.container}>
          <Text style={dynamicStyles.label}>Email or Username</Text>
          <TextInput
            value={login}
            onChangeText={setLogin}
            placeholder='ElSeniorDeTango'
            autoCorrect={false}
            autoComplete='off'
            autoCapitalize='none'
            textContentType='oneTimeCode'
            style={dynamicStyles.input}
          />

          <Text style={dynamicStyles.label}>Password</Text>
          <TextInput
            value={password}
            onChangeText={setPassword}
            placeholder=""
            style={dynamicStyles.input}
            secureTextEntry
          />

          <Button
            onPress={signIn}
            disabled={loading}
            text={loading ? 'Signing in...' : 'Sign in'}
          />
          <Link replace href="/register" style={dynamicStyles.textButton}>
            Create an account
          </Link>
        </View>
      </KeyboardAvoidingView>
    </View>
  );
};

export default LoginScreen;