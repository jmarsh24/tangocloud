import AntDesign from '@expo/vector-icons/AntDesign';
import { Link, Tabs } from 'expo-router';
import { useColorScheme, View, StyleSheet, Image } from 'react-native';
import { BottomTabBar } from '@react-navigation/bottom-tabs';

import Colors from '@/constants/Colors';
import Player from '@/components/Player';

/**
 * You can explore the built-in icon families and icons on the web at https://icons.expo.fyi/
 */
function TabBarIcon(props: {
  name: React.ComponentProps<typeof AntDesign>['name'];
  color: string;
}) {
  return <AntDesign size={22} style={{ marginBottom: -3 }} {...props} />;
}

export default function TabLayout() {
  const colorScheme = useColorScheme();

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
          tabBarIcon: ({ color }) => <TabBarIcon name="home" color={color} />,
          headerLeft: () => (
            <Link href="/modal" asChild>
              <Image source={require('@/assets/images/avatar.jpg')} style={styles.image} />
            </Link>
          ),
        }}
      />
      <Tabs.Screen
        name="search"
        options={{
          title: 'Search',
          tabBarIcon: ({ color }) => <TabBarIcon name="search1" color={color} />,
          headerLeft: () => (
            <Link href="/modal" asChild>
              <Image source={require('@/assets/images/avatar.jpg')} style={styles.image} />
            </Link>
          ),
        }}
      />

      <Tabs.Screen
        name="library"
        options={{
          title: 'My Library',
          tabBarIcon: ({ color }) => <TabBarIcon name="book" color={color} />,
          headerLeft: () => (
            <Link href="/modal" asChild>
              <Image source={require('@/assets/images/avatar.jpg')} style={styles.image} />
            </Link>
          ),
        }}
      />
    </Tabs>
  );
}

const styles = StyleSheet.create({
  image: {
    width: 30,
    height: 30,
    borderRadius: 15,
    marginLeft: 10,
  },
});