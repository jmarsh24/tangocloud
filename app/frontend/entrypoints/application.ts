import "vite/modulepreload-polyfill";
import "@hotwired/turbo-rails";
import { Application } from "@hotwired/stimulus";
import { start } from "@nerdgeschoss/shimmer";
import { registerControllers } from "stimulus-vite-helpers";

const application = Application.start();
application.debug = false;
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
const controllers = import.meta.globEager("../controllers/**/*_controller.ts");
registerControllers(application, controllers);
start({ application });
