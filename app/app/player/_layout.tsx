import { Stack } from "expo-router";
import { View } from "react-native";
import { defaultStyles } from "@/styles";

export const PlayerLayout = () => {
  return (
    <View style={defaultStyles.container}>
      <Stack>
        <Stack.Screen 
          name="index"
          options={{
            headerShown: false
          }} 
        />
      </Stack>
    </View>
  )
};

export default PlayerLayout;