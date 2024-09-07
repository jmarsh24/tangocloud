import { useAuth } from "@/providers/AuthProvider";
import { Redirect } from "expo-router";

const Page = () => {
  const { authState } = useAuth();

  if (authState.authenticated) return <Redirect href="/(root)/(tabs)/home" />;

  return <Redirect href="/(auth)/welcome" />;
};

export default Page;
