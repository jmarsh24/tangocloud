import { TracksList } from '@/components/TracksList'
import { screenPadding } from '@/constants/tokens'
import { SEARCH_RECORDINGS } from '@/graphql'
import { generateTracksListId } from '@/helpers/miscellaneous'
import { useNavigationSearch } from '@/hooks/useNavigationSearch'
import { defaultStyles } from '@/styles'
import { useQuery } from '@apollo/client'
import { useState, useEffect } from 'react'
import { ScrollView, Text, View } from 'react-native'

const SearchScreen = () => {
  const [searchQuery, setSearchQuery] = useState('')
  const ITEMS_PER_PAGE = 50

  const searchText = useNavigationSearch({
    searchBarOptions: { placeholder: 'Find in recordings' },
  })

  useEffect(() => {
    setSearchQuery(searchText)
  }, [searchText])

  const { data, loading, error } = useQuery(SEARCH_RECORDINGS, {
    variables: { query: searchQuery, first: ITEMS_PER_PAGE },
  })

  if (loading) {
    return (
      <View style={defaultStyles.container}>
        <Text>Loading...</Text>
      </View>
    )
  }

  if (error) {
    console.error('Error fetching recordings:', error)
    return (
      <View style={defaultStyles.container}>
        <Text>Error loading recordings. Please try again later.</Text>
      </View>
    )
  }

const tracks = data?.searchRecordings?.recordings.edges.map((edge) => {
  const node = edge.node;

  return {
    id: node.id,
    title: node.title || 'Unknown Title',
    artist: node.orchestra?.name || 'Unknown Orchestra',
    duration: node.digitalRemasters?.edges?.[0]?.node?.duration || 0,
    artwork: node.digitalRemasters?.edges?.[0]?.node?.album?.albumArt?.blob?.url || '',
    url: node.digitalRemasters?.edges?.[0]?.node?.audioVariants?.[0]?.audioFileUrl || '',
    singer: node.recordingSingers?.edges?.map(singerEdge => singerEdge.node.person.name).join(', ') || '',
    lyrics: '',
    year: node.year || 'Unknown Year',
    genre: node.genre?.name || 'Unknown Genre',
  }}) || [];

  return (
    <View style={defaultStyles.container}>
      <ScrollView
        contentInsetAdjustmentBehavior="automatic"
        keyboardDismissMode="on-drag"
        style={{ paddingHorizontal: screenPadding.horizontal }}
      >
        <TracksList
          id={generateTracksListId('songs', searchQuery)}
          tracks={tracks}
          scrollEnabled={false}
          hideQueueControls={true}
        />
      </ScrollView>
    </View>
  )
}

export default SearchScreen
