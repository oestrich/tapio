let mode = undefined;

if (process.env.WATCH == "true") {
  mode = "jit";
}

module.exports = {
  mode,
  purge: [
    '../lib/tapio/web/templates/**/*.html.eex',
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
