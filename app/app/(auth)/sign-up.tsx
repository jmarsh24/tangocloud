import React, { useState } from 'react';
import { View, Text, TextInput, StyleSheet, Alert, KeyboardAvoidingView, ScrollView, Platform, useColorScheme } from 'react-native';
import Button from '@/components/Button';
import Colors from '@/constants/Colors';
import { Link } from 'expo-router';
import { useAuth } from '@/providers/AuthProvider';

const SignUpScreen = () => {
  const colorScheme = useColorScheme();
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

  // Dynamic styles based on color scheme
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
      color: colorScheme === 'dark' ? Colors.dark.text : Colors.light.text, // Ensure text color is also adjusted
    },
    textButton: {
      alignSelf: 'center',
      fontWeight: 'bold',
      color: colorScheme === 'dark' ? Colors.dark.textSecondary : Colors.light.textSecondary,
      marginVertical: 10,
    },
  });

  return (
    <KeyboardAvoidingView
      style={{ flex: 1 }}
      behavior={Platform.OS === "ios" ? "padding" : "height"}
      keyboardVerticalOffset={Platform.OS === "ios" ? 64 : 0}
    >
      <ScrollView contentContainerStyle={{ flexGrow: 1 }}>
        <View style={dynamicStyles.container}>
          <Text style={dynamicStyles.label}>Username</Text>
          <TextInput
            value={username}
            onChangeText={setUsername}
            placeholder="ElSeniorDeTango"
            autoCorrect={false}
            autoComplete='off'
            autoCapitalize='none'
            textContentType='username'
            style={dynamicStyles.input}
          />

          <Text style={dynamicStyles.label}>Email</Text>
          <TextInput
            value={email}
            onChangeText={setEmail}
            placeholder="carlosdisarli@hotmail.com"
            autoCorrect={false}
            autoComplete='off'
            autoCapitalize='none'
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
            onPress={signUp}
            disabled={loading}
            text={loading ? 'Creating account...' : 'Create account'}
          />
          <Link replace href="/sign-in" style={dynamicStyles.textButton}>
            Sign in
          </Link>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
};

export default SignUpScreen;