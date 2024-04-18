import { StyleSheet, Image } from 'react-native';
import { useAuth } from '@/providers/AuthProvider';
import { useQuery } from '@apollo/client';
import { USER_PROFILE } from '@/graphql';
import { Tabs, Redirect } from 'expo-router';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import { FloatingPlayer } from '@/components/FloatingPlayer'
import { colors, fontSize } from '@/constants/tokens'
import { BlurView } from 'expo-blur'

const TabsNavigation = () => {
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
      return <Image source={{ uri: avatarUrl }} style={{width: 24, height: 24}} />;
    } else {
      return <MaterialIcons name="person" color={color} style={{ marginBottom: -3 }} />;
    }
  };

	return (
		<>
			<Tabs
				screenOptions={{
					tabBarActiveTintColor: colors.primary,
					tabBarLabelStyle: {
						fontSize: fontSize.xs,
						fontWeight: '500',
					},
					headerShown: false,
					tabBarStyle: {
						position: 'absolute',
						borderTopLeftRadius: 20,
						borderTopRightRadius: 20,
						borderTopWidth: 0,
						paddingTop: 8,
					},
					tabBarBackground: () => (
						<BlurView
							intensity={95}
							style={{
								...StyleSheet.absoluteFillObject,
								overflow: 'hidden',
								borderTopLeftRadius: 20,
								borderTopRightRadius: 20,
							}}
						/>
					),
				}}
			>
      <Tabs.Screen
        name="(playlists)"
        options={{
          title: 'Home',
          headerShown: false,
          tabBarIcon: ({ color }) => <MaterialIcons name="home" color={color} />
        }}
      />
      <Tabs.Screen
        name="search"
        options={{
          title: 'Search',
          headerShown: false,
          tabBarIcon: ({ color }) => <MaterialIcons name="search" color={color} />
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

			<FloatingPlayer
				style={{
					position: 'absolute',
					left: 8,
					right: 8,
					bottom: 78,
				}}
			/>
		</>
	)
}

export default TabsNavigation