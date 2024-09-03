import { CodegenConfig } from '@graphql-codegen/cli';

const config: CodegenConfig = {
  schema: '../schema.gql',
  documents: './app/graphql/**/*.ts',
  generates: {
    '../native/app/graphql/__generated__/': {
      preset: 'client',
      plugins: [
        'typescript',  // Generate TypeScript types for the schema
        'typescript-operations',  // Generate TypeScript types for the GraphQL operations (queries, mutations, etc.)
        'typescript-react-apollo',  // Generate Apollo hooks for React (React Native)
      ],
    },
  },
  hooks: {
    afterAllFileWrite: ['prettier --write'],
  },
};

export default config;
