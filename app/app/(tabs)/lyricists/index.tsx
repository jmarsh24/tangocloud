import { SEARCH_LYRICISTS } from '@/graphql'
import { useQuery } from '@apollo/client'
import { useTheme } from '@react-navigation/native'
import { ActivityIndicator, StyleSheet, Text } from 'react-native'
import { SafeAreaView } from 'react-native-safe-area-context'

const LyricistsScreen = () => {
	const { colors } = useTheme()
	const { data, loading, error } = useQuery(SEARCH_LYRICISTS, { variables: { query: '*' } })
	const lyricists = data?.searchLyricists?.edges.map((edge) => edge.node)

	if (loading) {
		return <ActivityIndicator />
	}
	if (error) {
		return <Text>Failed to fetch</Text>
	}

	return (
		<SafeAreaView edges={['right', 'top', 'left']} style={styles.container}>
			<Text style={[styles.title, { color: colors.text }]}>Lyricists</Text>
		</SafeAreaView>
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

export default LyricistsScreen
