import React from 'react';
import { View, StyleSheet, Text, Image, ActivityIndicator, useColorScheme } from 'react-native';
import { useAuth } from '@/providers/AuthProvider';
import { useQuery } from '@apollo/client';
import { Link } from 'expo-router';
import { CURRENT_USER_PROFILE } from '@/graphql';
import Button from '@/components/Button'
import Colors from '@/constants/Colors';

export default function LibraryScreen() {
  const { authState, onLogout } = useAuth();
  const { data, loading, error } = useQuery(CURRENT_USER_PROFILE, {
    skip: !authState.authenticated,
  });
  const scheme = useColorScheme();

  const dynamicStyles = StyleSheet.create({
    container: {
      flex: 1,
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'center',
      padding: 10,
      backgroundColor: scheme === 'dark' ? Colors.dark.background : Colors.light.background,
    },
    linkText: {
      color: scheme === 'dark' ? Colors.dark.text : Colors.light.text,
      margin: 8,
      fontSize: 16,
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
    return (
      <View style={dynamicStyles.container}>
        <Link href='/sign-in' asChild> 
          <Button onPress={onLogout} text="Sign In" />
        </Link>
        <Link href='/sign-up' asChild> 
          <Button onPress={onLogout} text="Sign Up" />
        </Link>
      </View>
    );
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
        <Button onPress={onLogout} text="Sign out" />
      </View>
    );
  }

  const currentUserProfile = data?.currentUserProfile;
  const username = currentUserProfile?.username;
  const email = currentUserProfile?.email;
  const avatar_url = currentUserProfile?.avatarUrl;
  return (
    <View style={dynamicStyles.container}>
      <Image source={{ uri: avatar_url }} style={styles.image} />
      {username && <Text style={dynamicStyles.header}>{username}</Text>}
      {email && <Text style={dynamicStyles.header}>{email}</Text>}
      <Button onPress={onLogout} text="Sign out" />
    </View>
  );
}

  const styles = StyleSheet.create({
    image: {
      width: 100,
      height: 100,
      borderRadius: 50,
    },
    link: {
      backgroundColor: Colors.light.buttonPrimary,
      padding: 15,
      marginVertical: 10,
      borderRadius: 100,
    }
  }
);
