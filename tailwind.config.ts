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
        montserrat: ['Montserrat', 'sans-serif'],
      },
      container: {
        center: true,
      },
      backgroundImage: {
        tango: 'radial-gradient(circle, rgba(55,0,70,0.20), rgba(80,0,110,0.15), rgba(20,0,40,0.10))',
        milonga: 'radial-gradient(circle, rgba(0,40,110,0.20), rgba(0,60,150,0.15), rgba(0,20,50,0.10))',
        vals: 'radial-gradient(circle, rgba(130,110,0,0.20), rgba(200,160,0,0.15), rgba(80,60,0,0.10))',
        default: 'radial-gradient(circle, rgba(45,45,45,0.20), rgba(30,30,30,0.15), rgba(10,10,10,0.10))',
      },
    },
  },
  plugins: [
    require('daisyui'),
    require('@tailwindcss/container-queries'),
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
};