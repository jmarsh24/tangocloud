import { ApolloClient, createHttpLink, InMemoryCache } from "@apollo/client";
import { setContext } from "@apollo/client/link/context";
import { useEffect, useState } from "react";
import { writeDB } from "./store";
import { relayStylePagination } from "@apollo/client/utilities";

export type GraphClient = ApolloClient<unknown>;

export function createClient(uri: string): GraphClient {
  const httpLink = createHttpLink({
    uri,
  });

  const authLink = setContext(async (_, { headers }) => {
    // get the authentication token from local storage if it exists
    const token = writeDB.get("accessToken");

    // return the headers to the context so httpLink can read them
    return {
      headers: {
        ...headers,
        authorization: token ? `Bearer ${token}` : "Bearer DEMO",
      },
    };
  });

  return new ApolloClient({
    link: authLink.concat(httpLink),
    cache: new InMemoryCache({
      typePolicies: {
        Depot: {
          fields: {
            transactions: relayStylePagination(),
          },
        },
      },
    }),
    defaultOptions: {
      watchQuery: {
        notifyOnNetworkStatusChange: true,
      },
    },
  });
}

export const useQuery = <T>(
  load: () => Promise<T>
): [T | undefined, boolean, Error | null, () => void] => {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);
  const [data, setData] = useState<T | undefined>(undefined);
  const [key, setKey] = useState(0);

  const reload = (): void => {
    setKey((v) => (v += 1));
  };

  const loadQuery = async (): Promise<void> => {
    setLoading(true);
    try {
      const resp = await load();

      setData(resp);
    } catch (error) {
      setError(error as Error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadQuery();
  }, [key]);

  return [data, loading, error, reload];
};
