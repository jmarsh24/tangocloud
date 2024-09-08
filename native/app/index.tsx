import { useAuth } from "@/providers/AuthProvider";
import { Redirect } from "expo-router";
import { useEffect, useState } from "react";
import { Text, View } from "react-native";

const Page = () => {
  const { authState } = useAuth();
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    if (authState.authenticated !== null) {
      setIsLoading(false);
    }
  }, [authState]);

  if (isLoading) {
    return <View><Text>Loading...</Text></View>;
  }

  if (authState.authenticated === true) {
    return <Redirect href="/(root)/(tabs)" />;
  }

  return <Redirect href="/(auth)/welcome" />;
};

export default Page;
