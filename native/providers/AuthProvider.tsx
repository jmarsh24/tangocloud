import { createContext, useContext, useEffect, useState, PropsWithChildren } from 'react';
import * as SecureStore from 'expo-secure-store';
import * as AppleAuthentication from 'expo-apple-authentication';
import { GoogleSignin } from '@react-native-google-signin/google-signin';
import axios, { AxiosError } from 'axios';

interface AuthState {
  token: string | null;
  refreshToken: string | null;
  authenticated: boolean | null;
}

interface AuthContextType {
  authState: AuthState;
  onRegister: (username: string, email: string, password: string) => Promise<any>;
  onLogin: (login: string, password: string) => Promise<any>;
  onAppleLogin: () => Promise<any>;
  onGoogleLogin: () => Promise<any>;
  onLogout: () => Promise<void>;
  refreshToken: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider = ({ children }: PropsWithChildren) => {
  const [authState, setAuthState] = useState<AuthState>({
    token: null,
    refreshToken: null,
    authenticated: null,
  });

  useEffect(() => {
    const loadToken = async () => {
      const token = await SecureStore.getItemAsync('token');
      const refreshToken = await SecureStore.getItemAsync('refreshToken');
      if (token) {
        setAuthState({
          token,
          refreshToken,
          authenticated: true,
        });
      }
    };
    loadToken();
  }, []);

  const refreshToken = async () => {
    if (!authState.refreshToken) return;

    try {
      const response = await axios.post(
        `${process.env.EXPO_PUBLIC_API_ENDPOINT}/refresh`,
        {},
        {
          headers: {
            Authorization: `Bearer ${authState.refreshToken}`,
          },
        }
      );

      const { access, refresh } = response.data;

      setAuthState({
        token: access,
        refreshToken: refresh,
        authenticated: true,
      });
      await SecureStore.setItemAsync('token', access);
      await SecureStore.setItemAsync('refreshToken', refresh);
    } catch (error) {
      const axiosError = error as AxiosError;
      throw new Error(axiosError.message);
    }
  };

  const register = async (username: string, email: string, password: string) => {
    try {
      const response = await axios.post(`${process.env.EXPO_PUBLIC_API_ENDPOINT}/users`, {
        user: { username, email, password },
      });

      return response.data;
    } catch (error) {
      const axiosError = error as AxiosError;
      throw new Error(axiosError.message);
    }
  };

  const login = async (login: string, password: string) => {
    try {
      const response = await axios.post(`${process.env.EXPO_PUBLIC_API_ENDPOINT}/login`, {
        login,
        password,
      });

      const { access, refresh } = response.data;

      setAuthState({
        token: access,
        refreshToken: refresh,
        authenticated: true,
      });

      await SecureStore.setItemAsync('token', access);
      await SecureStore.setItemAsync('refreshToken', refresh);
      return response.data;
    } catch (error) {
      const axiosError = error as AxiosError;
      throw new Error(axiosError.message);
    }
  };

  const appleLogin = async () => {
    try {
      const credential = await AppleAuthentication.signInAsync({
        requestedScopes: [
          AppleAuthentication.AppleAuthenticationScope.FULL_NAME,
          AppleAuthentication.AppleAuthenticationScope.EMAIL,
        ],
      });

      const response = await axios.post(`${process.env.EXPO_PUBLIC_API_ENDPOINT}/apple_login`, {
        userIdentifier: credential.user,
        identityToken: credential.identityToken,
        email: credential.email,
        firstName: credential.fullName?.givenName,
        lastName: credential.fullName?.familyName,
      });

      const { access, refresh } = response.data;

      setAuthState({
        token: access,
        refreshToken: refresh,
        authenticated: true,
      });

      await SecureStore.setItemAsync('token', access);
      await SecureStore.setItemAsync('refreshToken', refresh);
      return response.data;
    } catch (error) {
      const axiosError = error as AxiosError;
      throw new Error(axiosError.message);
    }
  };

  const googleLogin = async () => {
    try {
      await GoogleSignin.hasPlayServices();
      const userInfo = await GoogleSignin.signIn();
      const { idToken } = userInfo;

      const response = await axios.post(`${process.env.EXPO_PUBLIC_API_ENDPOINT}/google_login`, {
        idToken,
      });

      const { access, refresh } = response.data;

      setAuthState({
        token: access,
        refreshToken: refresh,
        authenticated: true,
      });

      await SecureStore.setItemAsync('token', access);
      await SecureStore.setItemAsync('refreshToken', refresh);
      return response.data;
    } catch (error) {
      const axiosError = error as AxiosError;
      throw new Error(axiosError.message);
    }
  };

  const logout = async () => {
    try {
      await axios.delete(`${process.env.EXPO_PUBLIC_API_ENDPOINT}/logout`, {
        headers: {
          Authorization: `Bearer ${authState.token}`,
        },
      });
    } catch (error) {
      // Handle error if needed
    } finally {
      await SecureStore.deleteItemAsync('token');
      await SecureStore.deleteItemAsync('refreshToken');
      setAuthState({
        token: null,
        refreshToken: null,
        authenticated: false,
      });
    }
  };

  const value = {
    authState,
    onRegister: register,
    onLogin: login,
    onAppleLogin: appleLogin,
    onGoogleLogin: googleLogin,
    onLogout: logout,
    refreshToken: refreshToken,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
