import { ApolloClient, InMemoryCache, ApolloProvider, HttpLink } from '@apollo/client';
import { setContext } from '@apollo/client/link/context';
import { PropsWithChildren } from 'react';
import * as SecureStore from 'expo-secure-store';

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

// Create the Apollo Client with the auth and HTTP link
const client = new ApolloClient({
  link: authLink.concat(httpLink), // Use the authLink with the httpLink
  cache: new InMemoryCache(),
});

// ApolloClientProvider component
const ApolloClientProvider = ({ children }: PropsWithChildren<{}>) => {
  return <ApolloProvider client={client}>{children}</ApolloProvider>;
};

export default ApolloClientProvider;