import { CodegenConfig } from '@graphql-codegen/cli';

const config: CodegenConfig = {
  schema: './schema.gql',
  documents: ['native/graphql/**/*.ts'],
  generates: {
    './native/app/generated/': {
      preset: 'client',
      plugins: [],
    },
  },
};

export default config;
