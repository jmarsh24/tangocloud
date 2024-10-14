import eslint from '@typescript-eslint/eslint-plugin';
import parser from '@typescript-eslint/parser';

export default [
  {
    ignores: ['node_modules/', 'generated/'],
    files: ['**/*.ts', '**/*.tsx'],
    languageOptions: {
      ecmaVersion: 2018,
      sourceType: 'module',
      parser: parser,
      globals: {
        window: 'readonly',
        document: 'readonly',
      },
    },
    plugins: {
      '@typescript-eslint': eslint
    },
    rules: {
      'no-console': 2,
      '@typescript-eslint/explicit-function-return-type': [
        'error',
        {
          allowExpressions: true,
        },
      ],
      eqeqeq: 2,
      '@typescript-eslint/ban-types': 0,
    },
  },
];
