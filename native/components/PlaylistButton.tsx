import { colors } from '@/constants/tokens'
import { Playlist } from '@/generated/graphql'
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
			onPress={() => router.push(`/(home)/playlists/${playlist.id}`)}
			style={{ flex: 1 }}
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
						flex: 1,
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
		flexDirection: 'row',
		gap: 8,
		backgroundColor: colors.playlistButtonBackground,
		paddingRight: 8,
		borderRadius: 4,
		overflow: 'hidden',
	},
	playlistArtworkImage: {
		width: 56,
		height: 56,
	},
	playlistNameText: {
		...defaultStyles.text,
		fontSize: 12,
		fontWeight: '600',
	},
})
