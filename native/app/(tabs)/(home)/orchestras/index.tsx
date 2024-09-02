import { SEARCH_ORCHESTRAS } from '@/graphql'
import { useQuery } from '@apollo/client'
import { useTheme } from '@react-navigation/native'
import { ActivityIndicator, StyleSheet, Text, View } from 'react-native'
import { Orchestra } from 'generated/graphql' // Assuming these types are generated

const OrchestrasScreen = () => {
	const { colors } = useTheme()
	const { data, loading, error } = useQuery(SEARCH_ORCHESTRAS, {
		variables: { query: '*' }
	})

	const orchestras: Orchestra[] = data?.searchOrchestras?.edges.map((edge: { node: Orchestra }) => edge.node) || []

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
			{orchestras.map((orchestra) => (
				<Text key={orchestra.id} style={[styles.item, { color: colors.text }]}>
					{orchestra.name}
				</Text>
			))}
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
	item: {
		fontSize: 18,
		marginVertical: 5,
	},
})

export default OrchestrasScreen
