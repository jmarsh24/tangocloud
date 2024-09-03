import { CodegenConfig } from '@graphql-codegen/cli';

const config: CodegenConfig = {
  schema: '../schema.gql',
  documents: ['app/**/*.tsx', 'model/**/*.ts', 'shared/**/*.ts', 'graphql/**/*.ts'],
  generates: {
    './graphql/__generated__/': {
      preset: 'client',
      plugins: [],
    },
  },
};

export default config;
