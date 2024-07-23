import { defineConfig } from "vite";
import * as path from "path";
import RubyPlugin from "vite-plugin-ruby";
import StimulusHMR from "vite-plugin-stimulus-hmr";
import FullReload from "vite-plugin-full-reload";
import sassGlobImports from "vite-plugin-sass-glob-import";

export default defineConfig({
  plugins: [
    RubyPlugin(),
    StimulusHMR(),
    FullReload(["config/routes.rb", "app/views/**/*", "config/locales/*.yml"], {
      delay: 200,
    }),
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
