import { ApolloClient, InMemoryCache, ApolloProvider, HttpLink } from '@apollo/client';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { setContext } from '@apollo/client/link/context';
import { PropsWithChildren, useEffect, useState } from 'react';
import * as SecureStore from 'expo-secure-store';
import { persistCache, AsyncStorageWrapper } from 'apollo3-cache-persist';

// Function to retrieve the auth token
async function getAuthToken(): Promise<string | null> {
  const token = await SecureStore.getItemAsync('token');
  return token;
}

// Create an HTTP link
const httpLink = new HttpLink({
  uri: process.env.EXPO_PUBLIC_GRAPHQL_ENDPOINT,
});

// Set up the authorization context
const authLink = setContext(async (_, { headers }) => {
  const token = await getAuthToken();
  return {
    headers: {
      ...headers,
      Authorization: token ? `Bearer ${token}` : "",
    },
  };
});

// Initialize Apollo Cache
const cache = new InMemoryCache();

// ApolloClientProvider component
const ApolloClientProvider = ({ children }: PropsWithChildren<{}>) => {
  const [client, setClient] = useState<ApolloClient<any> | null>(null);

  useEffect(() => {
    const setupApollo = async () => {
      // Wait for the cache to be persisted before creating the client
      await persistCache({
        cache,
        storage: new AsyncStorageWrapper(AsyncStorage),
      });

      // Create the Apollo Client with the auth and HTTP link
      const apolloClient = new ApolloClient({
        link: authLink.concat(httpLink),
        cache: cache,
      });

      setClient(apolloClient);
    };

    setupApollo();
  }, []);
  
   if (!client) {
    return null;
  }

  return <ApolloProvider client={client}>{children}</ApolloProvider>;
};

export default ApolloClientProvider;
