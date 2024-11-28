import * as Sentry from "@sentry/browser";

Sentry.init({
  dsn: "https://50ad11560b139ac596b2b1f5155bce94@o4504470653173760.ingest.us.sentry.io/4506663407124480",
});

export default Sentry;

Sentry.captureMessage("Hello, world!");

import * as Turbo from "@hotwired/turbo";
import TurboPower from "turbo_power";
TurboPower.initialize(Turbo.StreamActions);

import { Application } from "@hotwired/stimulus";
import { registerControllers } from "stimulus-vite-helpers";

declare global {
  interface Window {
    Stimulus: Application;
  }
}

const application = Application.start();

application.debug = false;
window.Stimulus = application;

const controllers = import.meta.glob("../**/*_controller.{js,ts}", {
  eager: true,
});
registerControllers(application, controllers);

export { application };
