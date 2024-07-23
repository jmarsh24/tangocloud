
module.exports = {
  env: {
    browser: true,
    es2021: true,
  },
  ignorePatterns: ['node_modules/', 'generated/'],
  parser: '@typescript-eslint/parser',
  extends: ['eslint:recommended', 'plugin:react/recommended', 'plugin:@typescript-eslint/recommended'],
  parserOptions: {
    ecmaVersion: 2018,
    sourceType: 'module',
  },
  plugins: ['react', '@typescript-eslint', 'react-hooks'],
  rules: {
    'no-console': 2,
    '@typescript-eslint/explicit-function-return-type': [
      'error',
      {
        allowExpressions: true,
      },
    ],
    'react/display-name': 0,
    'react/prop-types': 0,
    'react-hooks/rules-of-hooks': 'error', // Checks rules of Hooks
    eqeqeq: 2,
    '@typescript-eslint/ban-types': 0,
  },
  settings: {
    react: {
      version: 'detect', // Tells eslint-plugin-react to automatically detect the version of React to use
    },
  },
};
