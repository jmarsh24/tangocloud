import { Stack } from "expo-router";
import { View } from "react-native";
import { defaultStyles } from "@/styles";
import { StackScreenWithSearchBar } from "@/constants/layout";

const OrchestrasLayout = () => {
  return (
    <View style={defaultStyles.container}>
      <Stack 
        screenOptions={{ 
        ...StackScreenWithSearchBar,
        title: 'Orchestras', 
        headerShown: false }} 
      />
    </View>
  )
};

export default OrchestrasLayout;