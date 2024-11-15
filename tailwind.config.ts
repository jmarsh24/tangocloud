module.exports = {
  darkMode: 'class',
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
        montserrat: ['Montserrat', 'sans-serif']
      }
    }
  },
  plugins: [
    require('daisyui'),
  ],
  daisyui: {
    themes: [
      {
        tangocloudTheme: {
          primary: '#FF7700',
          secondary: '#ffb347',
          accent: '#ffab76',
          neutral: '#333333',
          'base-100': '#1e1e1e',
          'base-content': '#f5f5f5',
          info: '#3abff8',
          success: '#36d399',
          warning: '#fbbd23',
          error: '#f87272',
        },
      },
    ],
  },
}