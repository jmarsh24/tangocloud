import { ApolloClient, InMemoryCache, ApolloProvider } from '@apollo/client';
import * as SecureStore from 'expo-secure-store';
import { PropsWithChildren } from 'react';

const token = SecureStore.getItemAsync('token');

const client = new ApolloClient({
  uri: process.env.EXPO_PUBLIC_GRAPHQL_ENDPOINT,
  cache: new InMemoryCache(),
  headers: {
    Authorization: token ? `Bearer ${token}` : '',
  },
});

const ApolloClientProvider = ({ children }: PropsWithChildren<{}>) => {
  return <ApolloProvider client={client}>{children}</ApolloProvider>;
};

export default ApolloClientProvider;
;