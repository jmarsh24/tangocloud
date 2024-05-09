import { Stack } from "expo-router";
import { View } from "react-native";
import { defaultStyles } from "@/styles";
import { StackScreenWithSearchBar } from "@/constants/layout";

const OrchestrasLayout = () => {
  return (
    <View style={defaultStyles.container}>
      <Stack>
        <Stack.Screen
          name="index"
          options={{ 
          ...StackScreenWithSearchBar,
          title: 'Orchestras' }} 
        />
        <Stack.Screen
          name="[id]"
          options={{ 
          ...StackScreenWithSearchBar }}
        />
      </Stack>
    </View>
  )
};

export default OrchestrasLayout;