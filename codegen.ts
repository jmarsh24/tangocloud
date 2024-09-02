import { CodegenConfig } from '@graphql-codegen/cli';

const config: CodegenConfig = {
  schema: './schema.gql',
  documents: ['native/src/**/*.tsx', 'native/graphql/**/*.ts'],
  generates: {
    './native/src/graphql/__generated__/': {
      preset: 'client',
      plugins: [],
    },
  },
};

export default config;
