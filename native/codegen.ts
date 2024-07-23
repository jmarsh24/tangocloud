import type { CodegenConfig } from '@graphql-codegen/cli'

const config: CodegenConfig = {
	overwrite: true,
	schema: 'http://127.0.0.1:3000/api/graphql',
	documents: 'graphql/**/*.{tsx,ts}',
	generates: {
		'types/gql/': {
			preset: 'client',
			plugins: ['typescript', 'typescript-operations', 'typescript-react-apollo'],
		},
	},
}

export default config
