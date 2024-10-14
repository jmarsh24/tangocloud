import { defaultStyles } from '@/styles'
import { StackScreenWithSearchBar } from '@/constants/layout'
import { Stack, Link } from 'expo-router'
import { View } from 'react-native'
import Avatar from '@/components/Avatar'
import { CURRENT_USER } from '@/graphql'
import { useQuery } from '@apollo/client'

const SearchLayout = () => {
	const { data } = useQuery(CURRENT_USER)

	const avatarUrl = data?.currentUser?.avatar?.url

	return (
		<View style={defaultStyles.container}>
			<Stack>
				<Stack.Screen
					name="index"
					options={{
						...StackScreenWithSearchBar,
						title: 'Search',
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

export default SearchLayout
