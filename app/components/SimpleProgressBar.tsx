import { StyleSheet, View } from 'react-native'
import { useProgress } from 'react-native-track-player'

const SimpleProgressBar = () => {
	const { duration, position } = useProgress(500)

	const progressPercentage = duration > 0 ? (position / duration) * 100 : 0

	return (
		<View style={styles.progressContainer}>
			<View style={[styles.progressBar, { width: `${progressPercentage}%` }]} />
		</View>
	)
}

const styles = StyleSheet.create({
	progressContainer: {
		height: 2,
		width: '100%',
		backgroundColor: 'rgba(0,0,0,0.5)',
	},
	progressBar: {
		height: '100%',
		backgroundColor: '#fff',
	},
})

export default SimpleProgressBar
