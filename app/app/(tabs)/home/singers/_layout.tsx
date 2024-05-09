import { Stack } from "expo-router";
import { View } from "react-native";
import { defaultStyles } from "@/styles";
import { StackScreenWithSearchBar } from "@/constants/layout";

export const SingersLayout = () => {
  return (
    <View style={defaultStyles.container}>
      <Stack>
        <Stack.Screen 
          name="index"
          options={{ 
          ...StackScreenWithSearchBar,
          title: 'Singers' }} 
        />
        <Stack.Screen
          name="[id]"
          options={{ 
          ...StackScreenWithSearchBar,
          title: 'Search' }}
        />
      </Stack>
    </View>
  )
};

export default SingersLayout;