import { defaultStyles } from '@/styles'
import { Stack, Link } from 'expo-router'
import { View } from 'react-native'
import Avatar from '@/components/Avatar'
import { CURRENT_USER } from '@/graphql'
import { useQuery } from '@apollo/client'

const HomeLayout = () => {
	const { data } = useQuery(CURRENT_USER)

  const avatarUrl = data?.currentUser?.userPreference?.avatar?.url

	return (
		<View style={defaultStyles.container}>
			<Stack>
				<Stack.Screen
					name="index"
					options={{
						headerTitle: 'Home',
						headerLeft: () => (
							<Link href="/profile">
								<Avatar avatarUrl={avatarUrl} size={36} />
							</Link>
						),
					}}
				/>
				<Stack.Screen
					name="playlists"
					options={{
						headerShown: false,
					}}
				/>
				<Stack.Screen
					name="orchestras"
					options={{
						headerShown: false,
					}}
				/>
			</Stack>
		</View>
	)
}

export default HomeLayout
