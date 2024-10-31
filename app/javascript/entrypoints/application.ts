import * as Turbo from "@hotwired/turbo";

import TurboPower from "turbo_power";
TurboPower.initialize(Turbo.StreamActions);

import { Application } from "@hotwired/stimulus";
import { registerControllers } from "stimulus-vite-helpers";

import Player from '../player'

declare global {
  interface Window {
    App: {
      player: Player;
    };
    Stimulus: Application;
  }
}


window.App = {
  player: new Player(),
}
const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

const controllers = import.meta.glob("../**/*_controller.{js,ts}", {
  eager: true,
});
registerControllers(application, controllers);

export { application };
