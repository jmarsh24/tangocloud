import { OrchestraTracksList } from '@/components/OrchestraTracksList'
import { screenPadding } from '@/constants/tokens'
import { ORCHESTRA } from '@/graphql'
import { defaultStyles } from '@/styles'
import { useQuery } from '@apollo/client'
import { useLocalSearchParams } from 'expo-router'
import { ActivityIndicator, ScrollView, Text, View } from 'react-native'

const OrchestraScreen = () => {
	const { id } = useLocalSearchParams<{ id: string }>()
	const { data, loading, error } = useQuery(ORCHESTRA, { variables: { id } })

	const orchestra = data?.orchestra
	if (loading) {
		return (
			<View style={defaultStyles.container}>
				<ActivityIndicator size="large" />
			</View>
		)
	}

	if (error) {
		return (
			<View style={defaultStyles.container}>
				<Text>Error loading orchestra.</Text>
			</View>
		)
	}

	return (
		<View style={defaultStyles.container}>
			<ScrollView
				contentInsetAdjustmentBehavior="automatic"
				style={{ paddingHorizontal: screenPadding.horizontal }}
			>
				<OrchestraTracksList orchestra={orchestra} />
			</ScrollView>
		</View>
	)
}

export default OrchestraScreen
