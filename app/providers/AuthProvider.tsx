import React, { createContext, useContext, useEffect, useState, PropsWithChildren } from 'react';
import { useApolloClient, ApolloError } from '@apollo/client';
import { REGISTER, LOGIN } from '@/graphql';
import * as SecureStore from 'expo-secure-store';

interface AuthState {
  token: string | null;
  authenticated: boolean | null;
}

interface AuthContextType {
  authState: AuthState;
  onRegister: (username: string, email: string, password: string) => Promise<any>;
  onLogin: (login: string, password: string) => Promise<any>;
  onLogout: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider = ({ children }: PropsWithChildren) => {
  const apolloClient = useApolloClient();
  const [authState, setAuthState] = useState<AuthState>({
    token: null,
    authenticated: null,
  });

  useEffect(() => {
    const loadToken = async () => {
      const token = await SecureStore.getItemAsync('token');
      if (token) {
        setAuthState({
          token: token,
          authenticated: true,
        });
      }
    };
    loadToken();
  }, []);

  const register = async (username: string, email: string, password: string) => {
    try {
      const { data } = await apolloClient.mutate({
        mutation: REGISTER,
        variables: { username, email, password },
      });

      return data.register;
    } catch (error) {
      const apolloError = error as ApolloError;
      throw new Error(apolloError.message);
    }
  };

  const login = async (login: string, password: string) => {
    try {
      const { data } = await apolloClient.mutate({
        mutation: LOGIN,
        variables: { login, password },
      });

      setAuthState({
        token: data.login.token,
        authenticated: true,
      });

      await SecureStore.setItemAsync('token', data.login.token);
      return data.login;
    } catch (error) {
      const apolloError = error as ApolloError;
      throw new Error(apolloError.message);
    }
  };

  const logout = async () => {
    await SecureStore.deleteItemAsync('token');
    setAuthState({
      token: null,
      authenticated: false,
    });
  };

  const value = {
    authState,
    onRegister: register,
    onLogin: login,
    onLogout: logout,
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