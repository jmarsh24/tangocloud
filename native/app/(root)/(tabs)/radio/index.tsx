// Radio.tsx
import React, { useState } from 'react';
import { View, StyleSheet, SafeAreaView, Text } from 'react-native';
import { defaultStyles } from '@/styles';
import { useQuery } from '@apollo/client';
import { SEARCH_RECORDINGS } from '@/graphql';
import FilterRow from '@/components/FilterRow';
import RecordingList from '@/components/RecordingList';

interface FilterItem {
  key: string;
  docCount: number;
}

interface RecordingNode {
  node: {
    composition: {
      title: string;
    };
  };
}

interface Aggregations {
  orchestra: FilterItem[];
  orchestraPeriods: FilterItem[];
  timePeriod: FilterItem[];
  genre: FilterItem[];
  singers: FilterItem[];
  year: FilterItem[];
}

interface ActiveFilters {
  orchestra: string | null;
  orchestraPeriods: string | null;
  timePeriod: string | null;
  genre: string | null;
  singers: string | null;
  year: string | null;
}

interface LoadingState {
  orchestra: boolean;
  orchestraPeriods: boolean;
  timePeriod: boolean;
  genre: boolean;
  singers: boolean;
  year: boolean;
}

const Radio: React.FC = () => {
  const [activeFilters, setActiveFilters] = useState<ActiveFilters>({
    orchestra: null,
    orchestraPeriods: null,
    timePeriod: null,
    genre: null,
    singers: null,
    year: null,
  });

  const [loadingState, setLoadingState] = useState<LoadingState>({
    orchestra: false,
    orchestraPeriods: false,
    timePeriod: false,
    genre: false,
    singers: false,
    year: false,
  });

  const toggleFilter = (category: keyof ActiveFilters, key: string) => {
    setActiveFilters((prevFilters) => ({
      ...prevFilters,
      [category]: prevFilters[category] === key ? null : key,
    }));
    refireQueryOnFilterChange(category);
  };

  const filterVariables: any = {};
  if (activeFilters.orchestra) filterVariables.orchestra = activeFilters.orchestra;
  if (activeFilters.orchestraPeriods)
    filterVariables.orchestraPeriods = activeFilters.orchestraPeriods;
  if (activeFilters.timePeriod) filterVariables.timePeriod = activeFilters.timePeriod;
  if (activeFilters.genre) filterVariables.genre = activeFilters.genre;
  if (activeFilters.singers) filterVariables.singers = activeFilters.singers;
  if (activeFilters.year) filterVariables.year = activeFilters.year;

  const { data, loading, error, refetch } = useQuery(SEARCH_RECORDINGS, {
    variables: {
      filters: filterVariables,
      aggs: [
        { field: 'orchestra' },
        { field: 'orchestraPeriods' },
        { field: 'timePeriod' },
        { field: 'genre' },
        { field: 'singers' },
        { field: 'year' },
      ],
    },
    fetchPolicy: 'cache-first',
  });

  const refireQueryOnFilterChange = async (category: keyof ActiveFilters) => {
    setLoadingState((prevState) => ({ ...prevState, [category]: true }));

    await refetch({
      filters: filterVariables,
      aggs: [
        { field: 'orchestra' },
        { field: 'orchestraPeriods' },
        { field: 'timePeriod' },
        { field: 'genre' },
        { field: 'singers' },
        { field: 'year' },
      ],
    });

    setLoadingState((prevState) => ({ ...prevState, [category]: false }));
  };

  if (error) {
    console.error('Error fetching search results:', error);
    return (
      <SafeAreaView style={styles.container}>
        <Text style={styles.text}>Error fetching search results</Text>
      </SafeAreaView>
    );
  }

  const aggregations: Aggregations = data?.searchRecordings.aggregations || {};
  const recordingResults: RecordingNode[] = data?.searchRecordings.recordings.edges || [];

  const sortByKey = (data: FilterItem[]) => data.slice().sort((a, b) => a.key.localeCompare(b.key));
  const sortByNumericKey = (data: FilterItem[]) =>
    data.slice().sort((a, b) => parseInt(a.key) - parseInt(b.key));
  const sortByDocCountDesc = (data: FilterItem[]) =>
    data.slice().sort((a, b) => b.docCount - a.docCount);

  const sortByActiveFilter = (data: FilterItem[], activeFilter: string | null) => {
    if (!activeFilter) return data;
    const activeItem = data.find((item) => item.key === activeFilter);
    if (!activeItem) return data;
    return [activeItem, ...data.filter((item) => item.key !== activeFilter)];
  };

  return (
    <View style={[defaultStyles.container, styles.container]}>
      {aggregations.orchestra && aggregations.orchestra.length > 0 && (
        <FilterRow
          title="Orchestras"
          data={sortByActiveFilter(sortByDocCountDesc(aggregations.orchestra), activeFilters.orchestra)}
          activeFilter={activeFilters.orchestra}
          loading={loadingState.orchestra}
          onToggleFilter={(key) => toggleFilter('orchestra', key)}
        />
      )}

      {aggregations.orchestraPeriods && aggregations.orchestraPeriods.length > 0 && (
        <FilterRow
          title="Orchestra Periods"
          data={sortByActiveFilter(aggregations.orchestraPeriods, activeFilters.orchestraPeriods)}
          activeFilter={activeFilters.orchestraPeriods}
          loading={loadingState.orchestraPeriods}
          onToggleFilter={(key) => toggleFilter('orchestraPeriods', key)}
        />
      )}

      {aggregations.genre && aggregations.genre.length > 0 && (
        <FilterRow
          title="Genres"
          data={sortByActiveFilter(aggregations.genre, activeFilters.genre)}
          activeFilter={activeFilters.genre}
          loading={loadingState.genre}
          onToggleFilter={(key) => toggleFilter('genre', key)}
        />
      )}

      {aggregations.singers && aggregations.singers.length > 0 && (
        <FilterRow
          title="Singers"
          data={sortByActiveFilter(aggregations.singers, activeFilters.singers)}
          activeFilter={activeFilters.singers}
          loading={loadingState.singers}
          onToggleFilter={(key) => toggleFilter('singers', key)}
        />
      )}

      {aggregations.year && aggregations.year.length > 0 && (
        <FilterRow
          title="Years"
          data={sortByActiveFilter(sortByNumericKey(aggregations.year), activeFilters.year)}
          activeFilter={activeFilters.year}
          loading={loadingState.year}
          onToggleFilter={(key) => toggleFilter('year', key)}
        />
      )}

      <RecordingList data={recordingResults} loading={loading} />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'column',
    gap: 10,
  },
  text: {
    fontSize: 16,
    color: 'white',
  },
});

export default Radio;
