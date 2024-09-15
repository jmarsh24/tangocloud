// FilterRow.tsx
import React from 'react';
import { View, Text, TouchableOpacity, ActivityIndicator, StyleSheet } from 'react-native';
import { FlashList } from '@shopify/flash-list';

interface FilterItem {
  key: string;
  docCount: number;
}

interface FilterRowProps {
  title: string;
  data: FilterItem[];
  activeFilter: string | null;
  loading: boolean;
  onToggleFilter: (key: string) => void;
}

const FilterRow: React.FC<FilterRowProps> = ({
  title,
  data,
  activeFilter,
  loading,
  onToggleFilter,
}) => {
  return (
    <View style={styles.filterRow}>
      <Text style={styles.heading}>{title}</Text>
      {loading ? (
        <ActivityIndicator size="small" color="white" />
      ) : (
        <FlashList
          data={data}
          keyExtractor={(item) => `${title}-${item.key}`}
          renderItem={({ item }) => (
            <TouchableOpacity
              style={[
                styles.filterButton,
                activeFilter === item.key && styles.activeFilterButton,
              ]}
              onPress={() => onToggleFilter(item.key)}
            >
              <Text style={styles.filterText}>{item.key}</Text>
            </TouchableOpacity>
          )}
          estimatedItemSize={50}
          horizontal
          showsHorizontalScrollIndicator={false}
        />
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  filterRow: {
    flexDirection: 'column',
    gap: 10,
  },
  heading: {
    fontSize: 18,
    color: 'white',
    fontWeight: 'bold',
    marginBottom: 5,
  },
  filterButton: {
    borderRadius: 5,
    padding: 5,
    backgroundColor: '#444',
    marginRight: 10,
  },
  activeFilterButton: {
    backgroundColor: '#5856D6',
  },
  filterText: {
    width: '100%',
    fontSize: 16,
    color: 'white',
  },
});

export default FilterRow;
