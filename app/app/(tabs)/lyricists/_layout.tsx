import { Stack } from "expo-router";
import { View } from "react-native";
import { StackScreenWithSearchBar } from "@/constants/layout";
import { defaultStyles } from "@/styles";

const LyricistsLayout = () => {
  return (
    <View style={defaultStyles.container}>
      <Stack>
        <Stack.Screen
        name="index"
        options={{
        ...StackScreenWithSearchBar,
        title: "Lyricists",
        headerShown: false }} />
        <Stack.Screen
        name="[id]"
        options={{
        ...StackScreenWithSearchBar,
        title: "Lyricist",
        headerShown: false }} />
      </Stack>
    </View>
  )
};

export default LyricistsLayout;