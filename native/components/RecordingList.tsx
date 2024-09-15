// RecordingList.tsx
import React from 'react';
import { View, Text, ActivityIndicator, StyleSheet } from 'react-native';
import { FlashList } from '@shopify/flash-list';

interface RecordingNode {
  node: {
    composition: {
      title: string;
    };
  };
}

interface RecordingListProps {
  data: RecordingNode[];
  loading: boolean;
}

const RecordingList: React.FC<RecordingListProps> = ({ data, loading }) => {
  return (
    <View style={styles.recordingListContainer}>
      {loading ? (
        <ActivityIndicator size="large" color="white" />
      ) : (
        <FlashList
          data={data}
          keyExtractor={(item, index) => `recording-${index}`}
          renderItem={({ item }) => (
            <Text style={styles.text}>{item.node.composition.title}</Text>
          )}
          estimatedItemSize={50}
          showsVerticalScrollIndicator
        />
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  recordingListContainer: {
    flex: 1,
    paddingHorizontal: 20,
    paddingVertical: 10,
  },
  text: {
    fontSize: 16,
    color: 'white',
  },
});

export default RecordingList;
