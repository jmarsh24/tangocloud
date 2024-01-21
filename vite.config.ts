import { defineConfig } from 'vite';
import RubyPlugin from 'vite-plugin-ruby';
import autoprefixer from 'autoprefixer';
import StimulusHMR from 'vite-plugin-stimulus-hmr';
import FullReload from 'vite-plugin-full-reload';
import sassGlobImports from 'vite-plugin-sass-glob-import';

export default defineConfig({
  plugins: [
    RubyPlugin(),
    StimulusHMR(),
    FullReload(['config/routes.rb', 'app/views/**/*', 'config/locales/*.yml'], {
      delay: 200,
    }),
    sassGlobImports(),
  ],
  css: {
    postcss: {
      plugins: [autoprefixer({})],
    },
  },
});
