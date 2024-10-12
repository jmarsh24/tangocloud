import { defineConfig } from "vite";
import * as path from "path";
import ViteRails from 'vite-plugin-rails';
import StimulusHMR from "vite-plugin-stimulus-hmr";
import FullReload from "vite-plugin-full-reload";
import sassGlobImports from "vite-plugin-sass-glob-import";

export default defineConfig({
  plugins: [
    ViteRails(),
    StimulusHMR(),
    FullReload(["config/routes.rb", "app/views/**/*", "config/locales/*.yml"]),
    sassGlobImports(),
  ],
  resolve: {
    alias: [
      {
        find: "@/lib",
        replacement: path.resolve(__dirname, "./app/frontend/components/lib/"),
      },
      {
        find: "@/components",
        replacement: path.resolve(__dirname, "./app/frontend/components/"),
      },
      {
        find: "@/entrypoints",
        replacement: path.resolve(__dirname, "./app/frontend/entrypoints"),
      },
    ],
  },
});
