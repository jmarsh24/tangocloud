import { CodegenConfig } from '@graphql-codegen/cli';

const config: CodegenConfig = {
  schema: '../schema.gql',
  documents: ['app/**/*.tsx', 'model/**/*.ts', 'shared/**/*.ts'],
  generates: {
    './generated/': {
      preset: 'client',
      plugins: [],
    },
  },
};

export default config;
