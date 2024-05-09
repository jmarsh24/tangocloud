import { defaultStyles } from '@/styles'
import { StyleSheet, Text, View } from 'react-native'

const HomeScreen = () => {
	return (
		<View style={[defaultStyles.container, styles.container]}>
			<Text style={[defaultStyles.text, styles.headerText]}>
				The people who are crazy enough to think they can change the world are the ones who do.
			</Text>
		</View>
	)
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		justifyContent: 'center',
		alignItems: 'center',
		paddingHorizontal: 20,
	},
	headerText: {
		fontSize: 24,
		fontWeight: 'bold',
		textAlign: 'center',
		marginHorizontal: 20,
		marginVertical: 20,
	},
})

export default HomeScreen
