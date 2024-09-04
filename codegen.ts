import { CodegenConfig } from '@graphql-codegen/cli';

const config: CodegenConfig = {
  schema: './schema.gql',
  documents: ['native/app/**/*.tsx', 'native/graphql/**/*.ts'],
  generates: {
    './native/graphql/__generated__/': {
      preset: 'client',
      plugins: [],
    },
  },
};

export default config;
