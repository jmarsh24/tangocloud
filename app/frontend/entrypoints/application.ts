import "./main.scss";
import "vite/modulepreload-polyfill";
import "@hotwired/turbo-rails";
import { Application } from "@hotwired/stimulus";
import { registerControllers } from "stimulus-vite-helpers";

const application = Application.start();
application.debug = false;
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
const controllers = import.meta.glob(
  ["../controllers/**/*_controller.ts", "../controllers/**/*_controller.js"],
  {
    eager: true,
  }
);

registerControllers(application, controllers);


