import { Stack } from "expo-router";
import { View } from "react-native";
import { StackScreenWithSearchBar } from "@/constants/layout";
import { defaultStyles } from "@/styles";

const ComposersLayout = () => {
  return (
    <View style={defaultStyles.container}>
      <Stack>
        <Stack.Screen
          name="index"
          options={{
          ...StackScreenWithSearchBar,
          title: "Composers", 
          headerShown: false }} 
        />
        <Stack.Screen
          name="[id]"
          options={{
          ...StackScreenWithSearchBar,
          title: "Composer",
          headerShown: false }}
        />
      </Stack>
    </View>
  )
};

export default ComposersLayout;