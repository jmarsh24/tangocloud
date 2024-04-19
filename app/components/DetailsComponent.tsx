import React from 'react'
import { StyleSheet, Text, View } from 'react-native'

export const DetailsComponent = ({ track, style }) => {
	if (!track) return null // Do not render if no track data is available

	return (
		<View style={[styles.container, style]}>
			{/* <Image source={{ uri: track.orchestra_image_url }} style={styles.image} /> */}
			<Text style={styles.titleText}>{track.artist}</Text>
			<Text style={styles.detailsText}>Title: {track.title}</Text>
			<Text style={styles.detailsText}>Year: {track.year}</Text>
			<Text style={styles.detailsText}>Genre: {track.genre}</Text>
			<Text style={styles.detailsText}>Orchestra: {track.artist}</Text>
			<Text style={styles.detailsText}>Singers: {track.singer}</Text>
			<Text style={styles.detailsText}>Composers: {track.composer}</Text>
			<Text style={styles.detailsText}>Lyricists: {track.lyricist}</Text>
		</View>
	)
}

const styles = StyleSheet.create({
	container: {
		padding: 20,
		backgroundColor: 'rgba(0,0,0,0.5)',
		borderRadius: 10,
		marginTop: 20,
	},
	image: {
		width: 200,
		height: 200,
		borderRadius: 100,
		marginBottom: 10,
	},
	titleText: {
		fontSize: 18,
		fontWeight: 'bold',
		color: '#fff',
		marginBottom: 10,
	},
	detailsText: {
		fontSize: 16,
		color: '#fff',
		marginBottom: 5,
	},
})

export default DetailsComponent
