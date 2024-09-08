import { defaultStyles } from '@/styles'
import { Stack } from 'expo-router'
import { View } from 'react-native'
import { Link } from 'expo-router'
import { CURRENT_USER } from '@/graphql'
import { useQuery } from '@apollo/client'
import Avatar from '@/components/Avatar'

const RootLayout = () => {
  const { data } = useQuery(CURRENT_USER)

  const avatarUrl = data?.currentUser?.userPreference?.avatar?.blob?.url

  return (
    <View style={defaultStyles.container}>
      <Stack>
        <Stack.Screen
          name="(tabs)"
          options={{
            headerLeft: () => (
              <Link href='/profile' push>
                <Avatar avatarUrl={avatarUrl} size={36} />
              </Link>
            ),
          }}
        />
        <Stack.Screen name="recordings" options={{ headerShown: false }} />
        <Stack.Screen name="player" options={{ headerShown: false, presentation: 'modal' }} />
        <Stack.Screen name="queue" options={{ headerShown: false, animation: 'fade' }} />
        <Stack.Screen name="lyrics" options={{ headerShown: false, animation: 'fade' }} />
      </Stack>
    </View>
  )
}

export default RootLayout
