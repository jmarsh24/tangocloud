import React from 'react';
import AntDesign from '@expo/vector-icons/AntDesign';
import { useColorScheme, View, StyleSheet, Image } from 'react-native';
import { useAuth } from '@/providers/AuthProvider';
import { useQuery } from '@apollo/client';
import { USER_PROFILE } from '@/graphql';
import { BottomTabBar } from '@react-navigation/bottom-tabs';
import { Tabs, Redirect } from 'expo-router';
import Colors from '@/constants/Colors';
import Player from '@/components/Player';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';

function TabBarIcon(props: {
  name: React.ComponentProps<typeof MaterialIcons>['name'];
  color: string;
}) {
  return <MaterialIcons size={22} style={{ marginBottom: -3 }} {...props} />;
}

export default function TabLayout() {
  const colorScheme = useColorScheme();
  const { authState } = useAuth();

  const { data, loading, error } = useQuery(USER_PROFILE, {
    skip: !authState.authenticated,
  });

  if (loading) {
    return null;
  }

  if (error) {
    console.error('Error fetching user:', error);
  }

  if (!authState.authenticated) {
    return <Redirect href="/login" />;
  }

  const avatarUrl = data?.userProfile?.avatarUrl;

  const youIcon = (color) => {
    if (authState?.authenticated && avatarUrl) {
      return <Image source={{ uri: avatarUrl }} style={styles.image} />;
    } else {
      return <AntDesign name="user" size={22} color={color} style={{ marginBottom: -3 }} />;
    }
  };

  return (
    <Tabs
      screenOptions={{
        tabBarActiveTintColor: Colors[colorScheme ?? 'light'].tint,
      }}
      tabBar={(props) => (
        <View>
          <Player />
          <BottomTabBar {...props} />
        </View>
      )}
    >
      <Tabs.Screen
        name="playlists"
        options={{
          title: 'Home',
          headerShown: false,
          tabBarIcon: ({ color }) => <TabBarIcon name="home" color={color} />
        }}
      />
      <Tabs.Screen
        name="search"
        options={{
          title: 'Search',
          headerShown: false,
          tabBarIcon: ({ color }) => <TabBarIcon name="search" color={color} />
        }}
      />
      <Tabs.Screen
        name="you"
        options={{
          title: 'Your Profile',
          headerShown: false,
          tabBarIcon: ({ color }) => youIcon(color)
        }}
      />
      <Tabs.Screen
        name="recordings"
        options={{
          href: null,
          headerShown: false
        }}
      />
      <Tabs.Screen
        name="home"
        options={{
          href: null,
          headerShown: false
        }}
      />
      <Tabs.Screen
        name="orchestras"
        options={{
          href: null,
          headerShown: false
        }} 
      />
      <Tabs.Screen
        name="lyricists"
        options={{
          href: null,
          headerShown: false
        }}
      />
      <Tabs.Screen
        name="composers"
        options={{
          href: null,
          headerShown: false
        }}
      />
      <Tabs.Screen
        name="singers"
        options={{
          href: null,
          headerShown: false
        }}
      />
      <Tabs.Screen
        name="library"
        options={{
          href: null,
          headerShown: false
        }}
      />
    </Tabs>
  );
}

const styles = StyleSheet.create({
  image: {
    width: 24,
    height: 24,
    borderRadius: 12,
  },
});
