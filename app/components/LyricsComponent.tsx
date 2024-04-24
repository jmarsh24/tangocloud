import React from 'react'
import { StyleSheet, Text, View } from 'react-native'

export const LyricsComponent = ({ lyrics, style }) => {
	if (!lyrics) return null // Do not render if no lyrics are available

	return (
		<View style={[styles.container, style]}>
			<Text style={styles.lyricsText}>{lyrics}</Text>
		</View>
	)
}

const styles = StyleSheet.create({
	container: {
		padding: 20,
		backgroundColor: 'rgba(0,0,0,0.6)',
		borderRadius: 10,
	},
	lyricsText: {
		color: '#fff',
		fontSize: 16,
		lineHeight: 24,
	},
})
