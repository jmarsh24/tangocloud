import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { useApolloClient } from '@apollo/client';
import { LOGIN_MUTATION, WHO_AM_I } from '@/graphql';

type Session = {
  token: string;
  user: any;
};

type AuthData = {
  user: any;
  session: Session;
  loading: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
  isAdmin: boolean;
};

const AuthContext = createContext<AuthData | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<any>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const apolloClient = useApolloClient();

  const login = async (loginInput: string, password: string) => { 
  setLoading(true);
  try {
    const { data } = await apolloClient.mutate({
      mutation: LOGIN_MUTATION,
      variables: { login: loginInput, password: password },
    });
    const { token, user } = data.signIn;
    debugger;

    localStorage.setItem('authToken', token);
    // await fetchUserProfile();

    setUser(user);
  } catch (error) {
    console.error('Login error:', error);
    throw new Error(error.message); // Improved error handling
  } finally {
    setLoading(false);
  }
};

  // const fetchUserProfile = async () => {
  //   const { data } = await apolloClient.query({
  //     query: WHO_AM_I,
  //     // You may need to set headers or context here to include the token
  //   });
  //   setUser(data.profile);
  // };

  const logout = () => {
    // Clear user session and token
    setUser(null);
    localStorage.removeItem('authToken');
    // Reset Apollo store or perform other cleanup
    apolloClient.resetStore();
  };

  useEffect(() => {
    // Implement a mechanism to check if the user is already logged in on initial load
    // For example, check for a stored token and validate it or fetch user profile
    const initAuth = async () => {
      const token = localStorage.getItem('authToken');
      if (token) {
        await fetchUserProfile(); // Ensure this uses the token to fetch the profile
      }
      setLoading(false);
    };

    initAuth();
  }, []);

  return (
    <AuthContext.Provider value={{ user, loading, login, logout, isAdmin: user?.group === 'ADMIN' }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};