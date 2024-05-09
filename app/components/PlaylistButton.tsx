import { colors } from '@/constants/tokens'
import { Playlist } from '@/helpers/types'
import { defaultStyles } from '@/styles'
import { router } from 'expo-router'
import { StyleSheet, Text, TouchableHighlight, TouchableHighlightProps, View } from 'react-native'
import FastImage from 'react-native-fast-image'

type PlaylistButtonProps = {
	playlist: Playlist
} & TouchableHighlightProps

export const PlaylistButton = ({ playlist, ...props }: PlaylistButtonProps) => {
	return (
		<TouchableHighlight
			activeOpacity={0.8}
			{...props}
			onPress={() => router.push(`/home/playlists/${playlist.id}`)}
		>
			<View style={styles.playlistItemContainer}>
				<View>
					<FastImage
						source={{
							uri: playlist.imageUrl,
							priority: FastImage.priority.normal,
						}}
						style={styles.playlistArtworkImage}
					/>
				</View>

				<View
					style={{
						justifyContent: 'center',
					}}
				>
					<Text numberOfLines={2} style={styles.playlistNameText}>
						{playlist.title}
					</Text>
				</View>
			</View>
		</TouchableHighlight>
	)
}

const styles = StyleSheet.create({
	playlistItemContainer: {
		flex: 1,
		flexDirection: 'row',
		gap: 14,
		backgroundColor: colors.playlistButtonBackground,
		borderRadius: 4,
		flexGrow: 1,
		overflow: 'hidden',
	},
	playlistArtworkImage: {
		width: 56,
		height: 56,
	},
	playlistNameText: {
		...defaultStyles.text,
		fontSize: 10,
		fontWeight: '600',
	},
})
