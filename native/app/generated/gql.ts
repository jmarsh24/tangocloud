/* eslint-disable */
import * as types from './graphql';
import { TypedDocumentNode as DocumentNode } from '@graphql-typed-document-node/core';

/**
 * Map of all GraphQL operations in the project.
 *
 * This map has several performance disadvantages:
 * 1. It is not tree-shakeable, so it will include all operations in the project.
 * 2. It is not minifiable, so the string of a GraphQL query will be multiple times inside the bundle.
 * 3. It does not support dead code elimination, so it will add unused operations.
 *
 * Therefore it is highly recommended to use the babel-plugin for production.
 */
const documents = {
    "\n  mutation AddLikeToRecording($recordingId: ID!) {\n    addLikeToRecording(input: { recordingId: $recordingId }) {\n      like {\n        id\n        likeableType\n        likeableId\n        user {\n          id\n        }\n      }\n      success\n      errors\n    }\n  }\n": types.AddLikeToRecordingDocument,
    "\n  mutation appleLogin($input: AppleLoginInput!) {\n    appleLogin(input: $input) {\n      __typename\n      ... on AuthenticatedUser {\n        id\n        email\n        username\n        session {\n          access\n          accessExpiresAt\n          refresh\n          refreshExpiresAt\n        }\n      }\n      ... on FailedLogin {\n        error\n      }\n    }\n  }\n": types.AppleLoginDocument,
    "\n  mutation CreatePlayback($recordingId: ID!) {\n    createPlayback(input: { recordingId: $recordingId }) {\n      playback {\n        id\n        recording {\n          id\n        }\n      }\n    }\n  }\n": types.CreatePlaybackDocument,
    "\n\tmutation googleLogin($idToken: String!) {\n        googleLogin(input: {\n          idToken: $idToken\n        }) {\n         __typename\n          ...on AuthenticatedUser {\n            id\n            email\n            username\n            session {\n              access\n              accessExpiresAt\n              refresh\n              refreshExpiresAt\n            }\n          }\n          ...on FailedLogin {\n            error\n          }\n        }\n\t}\n": types.GoogleLoginDocument,
    "\n  mutation login($login: String!, $password: String!) {\n        login(\n          input: {\n            login: $login,\n            password: $password,\n          }\n        ) {\n          __typename\n          ...on AuthenticatedUser {\n            id\n            email\n            username\n            session {\n              access\n              accessExpiresAt\n              refresh\n              refreshExpiresAt\n            }\n          }\n          ...on FailedLogin {\n            error\n          }\n        }\n      }\n": types.LoginDocument,
    "\n  mutation RemoveLikeFromRecording($recordingId: ID!) {\n    removeLikeFromRecording(input: { recordingId: $recordingId }) {\n      success\n      errors\n    }\n  }\n": types.RemoveLikeFromRecordingDocument,
    "\n\tquery Composers($query: String) {\n\t\tcomposers(query: $query) {\n\t\t\tedges {\n\t\t\t\tnode {\n\t\t\t\t\tid\n\t\t\t\t\tname\n\t\t\t\t}\n\t\t\t}\n\t\t}\n\t}\n": types.ComposersDocument,
    "\n  query Orchestra($id: ID!) {\n    orchestra(id: $id) {\n      id\n      name\n      photo {\n        blob {\n          url\n        }\n      }\n      recordings {\n        edges {\n          node {\n            id\n            genre {\n              name\n            }\n            orchestra {\n              name\n            }\n            singers {\n              edges {\n                node {\n                  name\n                }\n              }\n            }\n          }\n        }\n      }\n    }\n  }\n": types.OrchestraDocument,
};

/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 *
 *
 * @example
 * ```ts
 * const query = gql(`query GetUser($id: ID!) { user(id: $id) { name } }`);
 * ```
 *
 * The query argument is unknown!
 * Please regenerate the types.
 */
export function graphql(source: string): unknown;

/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation AddLikeToRecording($recordingId: ID!) {\n    addLikeToRecording(input: { recordingId: $recordingId }) {\n      like {\n        id\n        likeableType\n        likeableId\n        user {\n          id\n        }\n      }\n      success\n      errors\n    }\n  }\n"): (typeof documents)["\n  mutation AddLikeToRecording($recordingId: ID!) {\n    addLikeToRecording(input: { recordingId: $recordingId }) {\n      like {\n        id\n        likeableType\n        likeableId\n        user {\n          id\n        }\n      }\n      success\n      errors\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation appleLogin($input: AppleLoginInput!) {\n    appleLogin(input: $input) {\n      __typename\n      ... on AuthenticatedUser {\n        id\n        email\n        username\n        session {\n          access\n          accessExpiresAt\n          refresh\n          refreshExpiresAt\n        }\n      }\n      ... on FailedLogin {\n        error\n      }\n    }\n  }\n"): (typeof documents)["\n  mutation appleLogin($input: AppleLoginInput!) {\n    appleLogin(input: $input) {\n      __typename\n      ... on AuthenticatedUser {\n        id\n        email\n        username\n        session {\n          access\n          accessExpiresAt\n          refresh\n          refreshExpiresAt\n        }\n      }\n      ... on FailedLogin {\n        error\n      }\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation CreatePlayback($recordingId: ID!) {\n    createPlayback(input: { recordingId: $recordingId }) {\n      playback {\n        id\n        recording {\n          id\n        }\n      }\n    }\n  }\n"): (typeof documents)["\n  mutation CreatePlayback($recordingId: ID!) {\n    createPlayback(input: { recordingId: $recordingId }) {\n      playback {\n        id\n        recording {\n          id\n        }\n      }\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n\tmutation googleLogin($idToken: String!) {\n        googleLogin(input: {\n          idToken: $idToken\n        }) {\n         __typename\n          ...on AuthenticatedUser {\n            id\n            email\n            username\n            session {\n              access\n              accessExpiresAt\n              refresh\n              refreshExpiresAt\n            }\n          }\n          ...on FailedLogin {\n            error\n          }\n        }\n\t}\n"): (typeof documents)["\n\tmutation googleLogin($idToken: String!) {\n        googleLogin(input: {\n          idToken: $idToken\n        }) {\n         __typename\n          ...on AuthenticatedUser {\n            id\n            email\n            username\n            session {\n              access\n              accessExpiresAt\n              refresh\n              refreshExpiresAt\n            }\n          }\n          ...on FailedLogin {\n            error\n          }\n        }\n\t}\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation login($login: String!, $password: String!) {\n        login(\n          input: {\n            login: $login,\n            password: $password,\n          }\n        ) {\n          __typename\n          ...on AuthenticatedUser {\n            id\n            email\n            username\n            session {\n              access\n              accessExpiresAt\n              refresh\n              refreshExpiresAt\n            }\n          }\n          ...on FailedLogin {\n            error\n          }\n        }\n      }\n"): (typeof documents)["\n  mutation login($login: String!, $password: String!) {\n        login(\n          input: {\n            login: $login,\n            password: $password,\n          }\n        ) {\n          __typename\n          ...on AuthenticatedUser {\n            id\n            email\n            username\n            session {\n              access\n              accessExpiresAt\n              refresh\n              refreshExpiresAt\n            }\n          }\n          ...on FailedLogin {\n            error\n          }\n        }\n      }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation RemoveLikeFromRecording($recordingId: ID!) {\n    removeLikeFromRecording(input: { recordingId: $recordingId }) {\n      success\n      errors\n    }\n  }\n"): (typeof documents)["\n  mutation RemoveLikeFromRecording($recordingId: ID!) {\n    removeLikeFromRecording(input: { recordingId: $recordingId }) {\n      success\n      errors\n    }\n  }\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n\tquery Composers($query: String) {\n\t\tcomposers(query: $query) {\n\t\t\tedges {\n\t\t\t\tnode {\n\t\t\t\t\tid\n\t\t\t\t\tname\n\t\t\t\t}\n\t\t\t}\n\t\t}\n\t}\n"): (typeof documents)["\n\tquery Composers($query: String) {\n\t\tcomposers(query: $query) {\n\t\t\tedges {\n\t\t\t\tnode {\n\t\t\t\t\tid\n\t\t\t\t\tname\n\t\t\t\t}\n\t\t\t}\n\t\t}\n\t}\n"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query Orchestra($id: ID!) {\n    orchestra(id: $id) {\n      id\n      name\n      photo {\n        blob {\n          url\n        }\n      }\n      recordings {\n        edges {\n          node {\n            id\n            genre {\n              name\n            }\n            orchestra {\n              name\n            }\n            singers {\n              edges {\n                node {\n                  name\n                }\n              }\n            }\n          }\n        }\n      }\n    }\n  }\n"): (typeof documents)["\n  query Orchestra($id: ID!) {\n    orchestra(id: $id) {\n      id\n      name\n      photo {\n        blob {\n          url\n        }\n      }\n      recordings {\n        edges {\n          node {\n            id\n            genre {\n              name\n            }\n            orchestra {\n              name\n            }\n            singers {\n              edges {\n                node {\n                  name\n                }\n              }\n            }\n          }\n        }\n      }\n    }\n  }\n"];

export function graphql(source: string) {
  return (documents as any)[source] ?? {};
}

export type DocumentType<TDocumentNode extends DocumentNode<any, any>> = TDocumentNode extends DocumentNode<  infer TType,  any>  ? TType  : never;