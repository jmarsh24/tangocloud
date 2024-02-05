import { ApolloClient, InMemoryCache, ApolloProvider } from '@apollo/client';
import { PropsWithChildren } from 'react';

const client = new ApolloClient({
  uri: 'http://localhost:3000/graphql',
  cache: new InMemoryCache(),
  headers: { 'authorization': 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiZDkyNmJjM2ItYWQ0ZC00MWUwLTkxYzUtZDRiMjhkMDk3NDkzIn0.tX71xEVTt_notixhRZIYpQU8MOYPM_IX-SYQC-neXMo' },
});

const ApolloClientProvider = ({ children }: PropsWithChildren) => {
  return <ApolloProvider client={client}>{children}</ApolloProvider>;
};

export default ApolloClientProvider;
;