module.exports = {
  darkMode: 'class',
  content: [
    "./app/views/**/*.{html,html.erb,erb}",
    "./app/frontend/components/**/*.{js,ts,jsx,tsx}",
    "./app/frontend/**/*.{js,ts,jsx,tsx}",
    "./app/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        circular: ['Circular', 'sans-serif'],
      },
    },
  },
  plugins: [],
    safelist: [
    'form-error'
  ]
};
