import React from 'react';
import { View, StyleSheet, Button, Text, ActivityIndicator, useColorScheme } from 'react-native';
import { useAuth } from '@/providers/AuthProvider';
import { useQuery } from '@apollo/client';
import { CURRENT_USER_PROFILE } from '@/graphql';
import Colors from '@/constants/Colors'; // Ensure this contains both light and dark mode colors

export default function LibraryScreen() {
  const { authState, onLogout } = useAuth();
  const { data, loading, error } = useQuery(CURRENT_USER_PROFILE, {
    skip: !authState.authenticated,
  });
  const scheme = useColorScheme();

  const dynamicStyles = StyleSheet.create({
    container: {
      flex: 1,
      justifyContent: 'center',
      alignItems: 'center',
      padding: 10,
      backgroundColor: scheme === 'dark' ? Colors.dark.background : Colors.light.background,
    },
    header: {
      fontSize: 20,
      fontWeight: 'bold',
      color: scheme === 'dark' ? Colors.dark.text : Colors.light.text,
      marginVertical: 8,
    },
    text: {
      color: scheme === 'dark' ? Colors.dark.text : Colors.light.text,
    }
  });

  if (!authState.authenticated) {
    return null;
  }

  if (loading) {
    return (
      <View style={dynamicStyles.container}>
        <ActivityIndicator size="large" color={Colors[scheme].tint} />
      </View>
    );
  }

  if (error) {
    return (
      <View style={dynamicStyles.container}>
        <Text style={dynamicStyles.text}>Error loading data...</Text>
        <Button onPress={onLogout} title="Sign out" />
      </View>
    );
  }

  const currentUserProfile = data?.currentUserProfile;
  const username = currentUserProfile?.username;
  const email = currentUserProfile?.email;
  const admin = currentUserProfile?.admin ? "Yes" : "No";

  return (
    <View style={dynamicStyles.container}>
      {username && <Text style={dynamicStyles.header}>Username: {username}</Text>}
      {email && <Text style={dynamicStyles.header}>Email: {email}</Text>}
      <Text style={dynamicStyles.header}>Admin: {admin}</Text>
      <Button onPress={onLogout} title="Sign out" />
    </View>
  );
}