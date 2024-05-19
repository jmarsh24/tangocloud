import React from 'react';
import { TouchableOpacity, View, Alert, Text } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Share } from 'react-native';
import { colors } from '@/constants/tokens';

export const ShareButton = ({ recording_id }) => {
  if (!recording_id) {
    return <Text>No recording ID provided.</Text>;
  }

  const shareUrl = `https://tangocloud.app/recordings/${recording_id}`;

  const handleShare = async () => {
    try {
      const result = await Share.share({
        url: shareUrl
      });

      if (result.action === Share.sharedAction) {
        if (result.activityType) {
          console.log('Shared with activity type:', result.activityType);
        } else {
          console.log('Shared successfully');
        }
      } else if (result.action === Share.dismissedAction) {
        console.log('Share dismissed');
      }
    } catch (error) {
      Alert.alert('Error', 'Failed to share the recording: ' + error.message);
    }
  };

  return (
    <View style={{ margin: 10 }}>
      <TouchableOpacity style={{ backgroundColor: colors.button, padding: 10, borderRadius: 5 }} onPress={handleShare}>
        <Ionicons name="share-outline" size={28} color={colors.text} />
      </TouchableOpacity>
    </View>
  );
};

export default ShareButton;