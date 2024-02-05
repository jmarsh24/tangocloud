import { ApolloClient, InMemoryCache, ApolloProvider } from '@apollo/client';
import { PropsWithChildren } from 'react';

const client = new ApolloClient({
  uri: process.env.EXPO_PUBLIC_GRAPHQL_ENDPOINT,
  cache: new InMemoryCache(),
  headers: { 'authorization': process.env.EXPO_PUBLIC_ADMIN_AUTH_TOKEN || 'default_token_or_empty_string' },
});

const ApolloClientProvider = ({ children }: PropsWithChildren<{}>) => {
  return <ApolloProvider client={client}>{children}</ApolloProvider>;
};

export default ApolloClientProvider;
;