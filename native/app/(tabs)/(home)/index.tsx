import { colors, screenPadding } from '@/constants/tokens'
import { defaultStyles } from '@/styles'
import _ from 'lodash'
import {
	SafeAreaView,
	ScrollView,
	StyleSheet,
	Text,
	View,
} from 'react-native'

const HomeScreen = () => {

	return (
		<SafeAreaView
			style={{
				...defaultStyles.container,
			}}
		>
			<ScrollView showsVerticalScrollIndicator={false}>
				<View style={{ gap: 10 }}>
					<Text style={[defaultStyles.text, styles.subHeader, { paddingHorizontal: 20 }]}>
						Moods
					</Text>
				</View>
			</ScrollView>
		</SafeAreaView>
	)
}

const styles = StyleSheet.create({
	header: {
		fontSize: 24,
		fontWeight: 'bold',
		color: colors.text,
	},
	tandaContainer: {
		position: 'relative',
		marginBottom: 24,
		height: 200,
	},
	tandaImage: {
		width: 300,
		height: 200,
		borderRadius: 8,
	},
	overlayTextContainer: {
		position: 'absolute',
		bottom: 0,
		left: 0,
		right: 0,
		backgroundColor: 'rgba(0, 0, 0, 0.5)',
		padding: 10,
	},
	tandaTitle: {
		color: 'white',
		fontWeight: 'bold',
		fontSize: 18,
	},
	recordingDetailContainer: {
		marginTop: 4,
	},
	recordingTitle: {
		color: 'white',
		fontWeight: 'bold',
	},
	recordingDetail: {
		color: 'white',
	},
	pillButton: {
		backgroundColor: 'rgba(46, 47, 51, 1)',
		paddingHorizontal: 15,
		paddingVertical: 8,
		borderRadius: 20,
		marginHorizontal: 5,
		marginBottom: 10,
		alignItems: 'center',
		justifyContent: 'center',
	},
	pillButtonText: {
		color: 'white',
		fontWeight: 'bold',
	},
	subHeader: {
		fontSize: 14,
		fontWeight: 'bold',
		color: 'rgba(235, 235, 245, 0.6)',
	},
	orchestraText: {
		color: 'white',
		fontWeight: 'bold',
		fontSize: 18,
	},
})

export default HomeScreen
