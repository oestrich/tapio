module.exports = {
  syntax: 'postcss-scss',
  plugins: [
    require('tailwindcss')('./tailwind.config.js'),
    require('autoprefixer'),
  ],
}
