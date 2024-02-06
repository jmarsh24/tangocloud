import { TypedDocumentNode } from "@apollo/client";

type VariablesOf<Type> =
  Type extends TypedDocumentNode<
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    any,
    infer Variables
  >
    ? Variables
    : never;

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type ResultOf<Type> =
  Type extends TypedDocumentNode<infer Result, any> ? Result : never;

export interface MockRequest<
  Query extends TypedDocumentNode,
  Result = ResultOf<Query>,
  Variables = VariablesOf<Query>,
> {
  request: {
    query: Query;
    variables?: Variables;
  };
  result: { data: Result };
}

interface TestConfig {
  testing: boolean;
  mocks: MockRequest<TypedDocumentNode>[];
}

export const testConfig: TestConfig = {
  testing: false,
  mocks: [],
};
