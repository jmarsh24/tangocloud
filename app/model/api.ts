import { createClient } from "../shared/api";
import Constants from "expo-constants";

export const client = createClient(Constants.expoConfig?.extra?.apiUrl);
