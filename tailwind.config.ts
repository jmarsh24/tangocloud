module.exports = {
  darkMode: 'class', // Ensure dark mode is based on a class
  content: [
    './app/views/**/*.html.erb',
    './app/components/**/*',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
  ],
  theme: {
    extend: {
      fontFamily: {
        circular: ['Circular', 'sans-serif'],
      },
    },
  },
  plugins: [
    require('daisyui'),
  ],
  daisyui: {
    themes: ['dark'],
  },
};
