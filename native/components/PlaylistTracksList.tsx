import { fontSize } from '@/constants/tokens'
import { trackTitleFilter } from '@/helpers/filter'
import { generateTracksListId } from '@/helpers/miscellaneous'
import { Playlist } from '@/generated/graphql'
import { useNavigationSearch } from '@/hooks/useNavigationSearch'
import { defaultStyles } from '@/styles'
import { useMemo } from 'react'
import { StyleSheet, Text, View } from 'react-native'
import FastImage from 'react-native-fast-image'
import { QueueControls } from './QueueControls'
import { TracksList } from './TracksList'

export const PlaylistTracksList = ({ playlist }: { playlist: Playlist }) => {
  const search = useNavigationSearch({
    searchBarOptions: {
      hideWhenScrolling: true,
      placeholder: 'Find in playlist',
    },
  })

  if (!playlist || !playlist.playlistItems) {
    return <Text>No playlist found or no items in the playlist</Text>
  }

  const recordings = useMemo(() => {
    return (
      playlist.playlistItems.edges.map(({ node: item }) => {
        const recording = item.item
        const digitalRemasterNode = recording?.digitalRemasters?.edges[0]?.node
        const audioVariantNode = digitalRemasterNode?.audioVariants?.edges[0]?.node

        return {
          id: recording?.id || '',
          title: recording?.title || '',
          artist: recording?.orchestra?.name || 'Unknown Artist',
          duration: digitalRemasterNode?.duration || 0,
          artwork: digitalRemasterNode?.album?.albumArt?.blob.url || '',
          url: audioVariantNode?.audioFile.blob.url || '',
          genre: recording?.genre?.name || 'Unknown Genre',
          year: recording?.year || 'Unknown Year',
        }
      }) || []
    )
  }, [playlist.playlistItems.edges])

  const filteredPlaylistTracks = useMemo(
    () => recordings.filter(trackTitleFilter(search)),
    [recordings, search],
  )

  return (
    <TracksList
      id={generateTracksListId(playlist.title, search)}
      scrollEnabled={false}
      hideQueueControls={true}
      ListHeaderComponentStyle={styles.playlistHeaderContainer}
      ListHeaderComponent={
        <View>
          <View style={styles.artworkImageContainer}>
            <FastImage
              source={{
                uri: playlist?.image?.blob?.url || require('@/assets/unknown_artist.png'),
                priority: FastImage.priority.high,
              }}
              style={styles.artworkImage}
            />
          </View>

          <Text numberOfLines={1} style={styles.playlistNameText}>
            {playlist.title}
          </Text>

          {search.length === 0 && <QueueControls style={{ paddingTop: 24 }} tracks={recordings} />}
        </View>
      }
      tracks={filteredPlaylistTracks}
    />
  )
}

const styles = StyleSheet.create({
  playlistHeaderContainer: {
    flex: 1,
    marginBottom: 32,
    gap: 24,
  },
  artworkImageContainer: {
    flexDirection: 'row',
    justifyContent: 'center',
  },
  artworkImage: {
    width: '85%',
    aspectRatio: 1,
    resizeMode: 'cover',
    borderRadius: 12,
  },
  playlistNameText: {
    ...defaultStyles.text,
    marginTop: 22,
    textAlign: 'center',
    fontSize: fontSize.lg,
    fontWeight: '800',
  },
})
