import { fontSize } from '@/constants/tokens'
import { trackTitleFilter } from '@/helpers/filter'
import { generateTracksListId } from '@/helpers/miscellaneous'
import { useNavigationSearch } from '@/hooks/useNavigationSearch'
import { defaultStyles } from '@/styles'
import { useMemo } from 'react'
import { StyleSheet, Text, View } from 'react-native'
import FastImage from 'react-native-fast-image'
import { QueueControls } from './QueueControls'
import { TracksList } from './TracksList'
import { Orchestra, RecordingEdge } from '@/graphql/__generated__/graphql'

export const OrchestraTracksList: React.FC<{ orchestra: Orchestra }> = ({ orchestra }) => {
  const search = useNavigationSearch({
    searchBarOptions: {
      hideWhenScrolling: true,
      placeholder: 'Find in recordings',
    },
  })

  const recordings = useMemo(() => {
    return orchestra?.recordings?.edges.map(({ node: item }: RecordingEdge) => ({
      id: item.id,
      title: item.composition?.title || '',
      artist: orchestra.name,
      duration: item.digitalRemasters.edges[0]?.node.duration || 0,
      artwork: item.digitalRemasters.edges[0]?.node.album?.albumArt?.url || '',
      url: item.digitalRemasters?.edges[0]?.node.audioVariants.edges[0]?.node?.url || '',
      genre: item.genre?.name || '',
      year: item.year || '',
      singer: item.singers[0]?.name || '',
    })) || []
  }, [orchestra])

  const filteredArtistTracks = useMemo(() => {
    return recordings.filter(trackTitleFilter(search))
  }, [recordings, search])

  return (
    <TracksList
      id={generateTracksListId(orchestra.name, search)}
      scrollEnabled={false}
      hideQueueControls={true}
      ListHeaderComponentStyle={styles.artistHeaderContainer}
      ListHeaderComponent={
        <View>
          <View style={styles.artworkImageContainer}>
            <FastImage
              source={orchestra.image?.url? { uri: orchestra?.image?.url, priority: FastImage.priority.normal } : require('@/assets/unknown_artist.png') }
              style={styles.artistImage}
            />
          </View>

          <Text numberOfLines={1} style={styles.artistNameText}>
            {orchestra.name}
          </Text>

          {search.length === 0 && (
            <QueueControls tracks={filteredArtistTracks} style={{ paddingTop: 24 }} />
          )}
        </View>
      }
      tracks={filteredArtistTracks}
    />
  )
}

const styles = StyleSheet.create({
  artistHeaderContainer: {
    flex: 1,
    marginBottom: 32,
  },
  artworkImageContainer: {
    flexDirection: 'row',
    justifyContent: 'center',
    height: 200,
  },
  artistImage: {
    width: '60%',
    height: '100%',
    resizeMode: 'cover',
    borderRadius: 128,
  },
  artistNameText: {
    ...defaultStyles.text,
    marginTop: 22,
    textAlign: 'center',
    fontSize: fontSize.lg,
    fontWeight: '800',
  },
})

export default OrchestraTracksList
