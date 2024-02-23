import React, { useEffect } from 'react';
import AntDesign from '@expo/vector-icons/AntDesign';
import { useColorScheme, View, StyleSheet, Image } from 'react-native';
import { useAuth } from '@/providers/AuthProvider';
import { useQuery } from '@apollo/client';
import { CURRENT_USER_PROFILE } from '@/graphql';
import { BottomTabBar } from '@react-navigation/bottom-tabs';
import { Tabs } from 'expo-router';
import Colors from '@/constants/Colors';
import Player from '@/components/Player';
import TrackPlayer from 'react-native-track-player';

function TabBarIcon(props: {
  name: React.ComponentProps<typeof AntDesign>['name'];
  color: string;
}) {
  return <AntDesign size={22} style={{ marginBottom: -3 }} {...props} />;
}

export default function TabLayout() {
  const colorScheme = useColorScheme();
  const { authState } = useAuth();

  const { data, loading, error } = useQuery(CURRENT_USER_PROFILE, {
    skip: !authState.authenticated,
  });

  const avatarUrl = data?.currentUserProfile?.avatarUrl;

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
        name="index"
        options={{
          title: 'Home',
          tabBarIcon: ({ color }) => <TabBarIcon name="home" color={color} />
        }}
      />
      <Tabs.Screen
        name="search"
        options={{
          title: 'Search',
          tabBarIcon: ({ color }) => <TabBarIcon name="search1" color={color} />
        }}
      />
      <Tabs.Screen
        name="you"
        options={{
          title: 'Your Profile',
          tabBarIcon: ({ color }) => youIcon(color)
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