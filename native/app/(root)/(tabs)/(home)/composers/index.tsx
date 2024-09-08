import { SEARCH_COMPOSERS } from '@/graphql'
import { useQuery } from '@apollo/client'
import { useTheme } from '@react-navigation/native'
import { ActivityIndicator, StyleSheet, Text, View } from 'react-native'

const ComposerScreen = () => {
	const { colors } = useTheme()
	const { data, loading, error } = useQuery(SEARCH_COMPOSERS, { variables: { query: '*' } })
	const composers = data?.searchComposers?.edges.map((edge) => edge.node)

	if (loading) {
		return <ActivityIndicator />
	}
	if (error) {
		return <Text>Failed to fetch</Text>
	}

	if (!composers) {
		return <Text>No composers found</Text>
	}

	return (
		<View style={styles.container}>
			<Text style={[styles.title, { color: colors.text }]}>Composers</Text>
		</View>
	)
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		paddingHorizontal: 20,
	},
	title: {
		fontSize: 24,
		fontWeight: 'bold',
		margin: 20,
	},
})

export default ComposerScreen
