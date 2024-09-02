import { CodegenConfig } from '@graphql-codegen/cli';

const config: CodegenConfig = {
  schema: '../schema.gql',
  generates: {
    './src/graphql/__generated__/': {
      preset: 'client',
      plugins: [],
    },
  },
};

export default config;
