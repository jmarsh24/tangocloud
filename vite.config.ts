import { defineConfig } from "vite";
import ViteRails from "vite-plugin-rails";

const env = process.env.RAILS_ENV || "development";

export default defineConfig({
  plugins: [
    ViteRails({
      fullReload: {
        additionalPaths: [
          "config/routes.rb",
          "app/views/**/*",
          "app/controllers/**/*",
          "app/models/**/*",
        ],
      },
    }),
  ],
  define: {
    "process.env.RAILS_ENV": JSON.stringify(env),
  },
});
