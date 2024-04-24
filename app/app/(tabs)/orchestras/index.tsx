import { SEARCH_ORCHESTRAS } from '@/graphql'
import { useQuery } from '@apollo/client'
import { useTheme } from '@react-navigation/native'
import { ActivityIndicator, StyleSheet, Text, View } from 'react-native'

const OrchestrasScreen = () => {
	const { colors } = useTheme()
	const { data, loading, error } = useQuery(SEARCH_ORCHESTRAS, { variables: { query: '*' } })
	const orchestras = data?.searchOrchestras?.edges.map((edge) => edge.node)

	if (loading) {
		return (
			<View style={styles.container}>
				<ActivityIndicator />
			</View>
		)
	}

	if (error) {
		return (
			<View style={styles.container}>
				<ActivityIndicator />
			</View>
		)
	}

	return (
		<View style={styles.container}>
			<Text style={[styles.title, { color: colors.text }]}>Orchestras</Text>
		</View>
	)
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		paddingHorizontal: 20,
		display: 'flex',
		flexDirection: 'column',
		justifyContent: 'flex-start',
	},
	title: {
		fontSize: 24,
		fontWeight: 'bold',
		margin: 20,
	},
})

export default OrchestrasScreen
