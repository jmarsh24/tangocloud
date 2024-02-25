import React from 'react';
import { View, StyleSheet, Text, Image, ActivityIndicator, useColorScheme } from 'react-native';
import { useAuth } from '@/providers/AuthProvider';
import { useQuery } from '@apollo/client';
import { Link } from 'expo-router';
import { USER_PROFILE } from '@/graphql';
import Button from '@/components/Button'
import Colors from '@/constants/Colors';
import { SafeAreaView } from 'react-native-safe-area-context';

export default function YouScreen() {
  const { authState, onLogout } = useAuth();
  const { data, loading, error } = useQuery(USER_PROFILE, {
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
      gap: 20,
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
        <Link href='/login' asChild> 
          <Button onPress={onLogout} text="Login" />
        </Link>
        <Link href='/register' asChild> 
          <Button onPress={onLogout} text="Register" />
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

  const user = data?.user;
  const username = user?.username;
  const email = user?.email;
  const avatar_url = user?.avatarUrl;
  
  return (
    <SafeAreaView style={dynamicStyles.container}>
      <Image source={{ uri: avatar_url }} style={styles.image} />
      {username && <Text style={dynamicStyles.header}>{username}</Text>}
      {email && <Text style={dynamicStyles.header}>{email}</Text>}
      <Button onPress={onLogout} text="Sign out" />
    </SafeAreaView>
  );
}

  const styles = StyleSheet.create({
    image: {
      width: 156,
      height: 156,
      borderRadius: 25,
    },
    link: {
      backgroundColor: Colors.light.buttonPrimary,
      padding: 15,
      marginVertical: 10,
      borderRadius: 100,
    }
  }
);
