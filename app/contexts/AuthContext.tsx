import { createContext, useContext, useEffect, useState } from 'react';
import { useApolloClient, ApolloError } from '@apollo/client';
import { REGISTER_MUTATION, LOGIN_MUTATION } from '@/graphql';
import * as SecureStore from 'expo-secure-store';

interface AuthProps {
  authState?: {
    token: string | null;
    authenticated: boolean | null;
  };
  onRegister?: (username: string, email: string, password: string) => Promise<any>;
  onLogin?: (email: string, password: string) => Promise<any>;
  onLogout?: () => Promise<any>;
}

const AuthContext = createContext<AuthProps>({});

export const useAuth = () => {
  return useContext(AuthContext);
}

export const AuthProvider = ({ children }: any) => {
  const apolloClient = useApolloClient();
  const [authState, setAuthState] = useState<{ 
    token: string | null,
    authenticated: boolean | null,
  }>({
    token: null,
    authenticated: null,
  });

  useEffect(() => {
    const loadToken = async () => {
      const token = await SecureStore.getItemAsync('token');
      console.log("stored:", token)

      if(token){
        setAuthState({
          token: token,
          authenticated: true,
        });
      }
    } 
    loadToken();
  }, []);

  const register = async (username: string, email: string, password: string) => {
    try {
      const { data } = await apolloClient.mutate({
        mutation: LOGIN_MUTATION,
        variables: { username: username, email: email, password: password },
      });

      setAuthState({
        token: data.signIn.token,
        authenticated: true,
      });

      await SecureStore.setItemAsync('token', data.signIn.token);
      
      return data.signIn;
      } catch (error) {
        const apolloError = error as ApolloError;
        console.error('Login error:', apolloError);
        throw new Error(apolloError.message);
    }
  };

  const login = async (login: string, password: string) => {
    try {
      const { data } = await apolloClient.mutate({
        mutation: REGISTER_MUTATION,
        variables: { login: login, password: password },
      });

      console.log("🚀 ~ file: AuthContext.tsx:40 ~ login ~ data:", data)

      setAuthState({
        token: data.signIn.token,
        authenticated: true,
      });

      await SecureStore.setItemAsync('token', data.signIn.token);
      return data.signIn;
      } catch (error) {
        const apolloError = error as ApolloError;
        console.error('Login error:', apolloError);
        throw new Error(apolloError.message);
    }
  };

  const logout = async () => {
    await SecureStore.deleteItemAsync('token');
    setAuthState({
      token: null,
      authenticated: false,
    })
  };

  const value = {
    onRegister: register,
    onLogin: login,
    onLogout: logout,
    authState,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}