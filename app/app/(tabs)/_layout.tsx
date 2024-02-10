import React from 'react';
import AntDesign from '@expo/vector-icons/AntDesign';
import { Tabs } from 'expo-router';
import { useColorScheme, View, StyleSheet, Image } from 'react-native';
import { BottomTabBar } from '@react-navigation/bottom-tabs';
import { useAuth } from '@/providers/AuthProvider';

import Colors from '@/constants/Colors';
import Player from '@/components/Player';

function TabBarIcon(props: {
  name: React.ComponentProps<typeof AntDesign>['name'];
  color: string;
}) {
  return <AntDesign size={22} style={{ marginBottom: -3 }} {...props} />;
}

export default function TabLayout() {
  const colorScheme = useColorScheme();
  const { authState } = useAuth();

  const youIcon = (color) => {
    if (authState?.authenticated) {
      return <Image source={require('@/assets/images/avatar.jpg')} style={styles.image} />;
    } else {
      return <AntDesign name="user" size={22} style={{ marginBottom: -3, color }} />;
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