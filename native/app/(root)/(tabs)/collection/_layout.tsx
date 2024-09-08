import { StackScreenWithSearchBar } from '@/constants/layout'
import { defaultStyles } from '@/styles'
import { Stack, Link } from 'expo-router'
import { View } from 'react-native'
import Avatar from '@/components/Avatar'
import { CURRENT_USER } from '@/graphql'
import { useQuery } from '@apollo/client'

const CollectionLayout = () => {
	const { data } = useQuery(CURRENT_USER)

	const avatarUrl = data?.currentUser?.userPreference?.avatar?.blob?.url
	return (
		<View style={defaultStyles.container}>
			<Stack>
				<Stack.Screen
					name="index"
					options={{
						...StackScreenWithSearchBar,
						headerTitle: 'Collection',
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

export default CollectionLayout
