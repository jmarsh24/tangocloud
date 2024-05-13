import { OrchestraTracksList } from '@/components/OrchestraTracksList'
import { screenPadding } from '@/constants/tokens'
import { FETCH_ORCHESTRA } from '@/graphql'
import { defaultStyles } from '@/styles'
import { useQuery } from '@apollo/client'
import { useLocalSearchParams } from 'expo-router'
import { ActivityIndicator, ScrollView, StyleSheet, Text, View } from 'react-native'

const OrchestraScreen = () => {
	const { id } = useLocalSearchParams<{ id: string }>()
	const { data, loading, error } = useQuery(FETCH_ORCHESTRA, { variables: { id } })

	const orchestra = data?.fetchOrchestra

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

const styles = StyleSheet.create({
	orchestraHeaderContainer: {
		flex: 1,
		marginBottom: 32,
		gap: 24,
	},
	header: {
		fontSize: 24,
		fontWeight: 'bold',
	},
	loadingContainer: {
		flex: 1,
		justifyContent: 'center',
		alignItems: 'center',
	},
	errorContainer: {
		flex: 1,
		justifyContent: 'center',
		alignItems: 'center',
	},
	imageContainer: {
		flexDirection: 'row',
		justifyContent: 'center',
	},
	image: {
		width: '100%',
		height: 300,
		resizeMode: 'cover',
		borderRadius: 12,
	},
	title: {
		position: 'absolute',
		bottom: 0,
		left: 0,
		fontSize: 24,
		fontWeight: 'bold',
		textAlign: 'center',
		paddingLeft: 10,
		paddingBottom: 10,
		color: '#FFFFFF',
		textShadowColor: 'rgba(0, 0, 0, 0.75)',
		textShadowOffset: { width: -1, height: 1 },
		textShadowRadius: 10,
	},
})

export default OrchestraScreen
