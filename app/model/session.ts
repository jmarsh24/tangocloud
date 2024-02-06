import * as AuthSession from "expo-auth-session";
import * as SecureStore from "expo-secure-store";
import Constants from "expo-constants";
import { writeDB } from "../shared/store";
import { client } from "./api";

const clientId = "lVm11BawDRYXamrnLvFCTFJHFDA5swJJ";
const domain = "https://login.tangocloud.app";
const authorizationEndpoint = domain + "/authorize";
const tokenEndpoint = domain + "/oauth/token";
export const redirectUri = AuthSession.makeRedirectUri({
  path: "auth",
  preferLocalhost: true,
});

const discovery: AuthSession.DiscoveryDocument = {
  authorizationEndpoint,
  tokenEndpoint,
};
const refreshTokenStorageKey = "refreshToken";

const useBiometricId = Constants.appOwnership !== "expo";

const authParameters: AuthSession.AuthRequestConfig = {
  redirectUri,
  clientId,
  responseType: "code",
  scopes: ["openid", "profile", "offline_access", "email"],
  extraParams: {
    audience: "https://tangocloud.app",
  },
  prompt: AuthSession.Prompt.Login,
};

export function useLogin(): () => Promise<void> {
  const [request, , promptAsync] = AuthSession.useAuthRequest(
    authParameters,
    discovery
  );

  return async () => {
    const response = await promptAsync();
    const code =
      (response.type === "success" && response?.params?.code) || null;
    if (code) {
      const result = await AuthSession.exchangeCodeAsync(
        {
          code,
          redirectUri,
          clientId,
          extraParams: {
            code_verifier: request?.codeVerifier ?? "",
          },
        },
        discovery
      );
      const refresh = result.refreshToken;
      const access = result.accessToken;
      if (refresh && access) {
        writeDB.set("accessToken", access);
        SecureStore.setItemAsync(refreshTokenStorageKey, refresh, {
          requireAuthentication: useBiometricId,
        });
      } else {
        throw new Error("Authentication did not return tokens.");
      }
    }
  };
}

export async function refreshToken(): Promise<void> {
  const refreshToken = await SecureStore.getItemAsync(refreshTokenStorageKey);
  if (!refreshToken) return;

  const token = await AuthSession.refreshAsync(
    { clientId, refreshToken },
    discovery
  );
  writeDB.set("accessToken", token.accessToken);
}

export async function logout({
  permanent = true,
}: { permanent?: boolean } = {}): Promise<void> {
  writeDB.set("accessToken", null);
  client.clearStore();
  if (permanent) {
    await SecureStore.deleteItemAsync(refreshTokenStorageKey);
    writeDB.set("accessToken", null);
  } else {
    // logout, but immediately trigger a quick login
    refreshToken();
  }
}
