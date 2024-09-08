import { defaultStyles } from '@/styles'
import { Stack, Link } from 'expo-router'
import { View } from 'react-native'
import Avatar from '@/components/Avatar'
import { CURRENT_USER } from '@/graphql'
import { useQuery } from '@apollo/client'

const RadioLayout = () => {
	const { data } = useQuery(CURRENT_USER)

	const avatarUrl = data?.currentUser?.userPreference?.avatar?.blob?.url

	return (
		<View style={defaultStyles.container}>
			<Stack>
				<Stack.Screen
					name="index"
					options={{
						headerTitle: 'Radio',
						headerLeft: () => (
							<Link href="/profile">
								<Avatar avatarUrl={avatarUrl} size={36} />
							</Link>
						),
					}}
					/>
			</Stack>
		</View>
	)
}

export default RadioLayout
