import { TouchableOpacity, View, Alert, Text } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import * as Sharing from 'expo-sharing';
import { colors } from '@/constants/tokens';

export const ShareButton = ({ recording_id }) => {
  if (!recording_id) {
    return <Text>No recording ID provided.</Text>;
  }

  const shareUrl = `https://tangocloud.app/recordings/${recording_id}`;

  const handleShare = async () => {
    const isAvailable = await Sharing.isAvailableAsync();

    if (isAvailable) {
        try {
            await Sharing.shareAsync(shareUrl);
        } catch (error) {
            Alert.alert('Error', 'Failed to share the recording.');
        }
    }
  };

  return (
      <View>
        <TouchableOpacity onPress={handleShare}>
            <Ionicons name="share-outline" size={28} color={colors.text} />
        </TouchableOpacity>
      </View>
  );
};

export default ShareButton;