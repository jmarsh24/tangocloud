import '@hotwired/turbo'

import { Application } from '@hotwired/stimulus'
import { registerControllers } from 'stimulus-vite-helpers'

declare global {
  interface Window {
    Stimulus: Application
  }
}

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

const controllers = import.meta.glob('../**/*_controller.ts', { eager: true })
registerControllers(application, controllers)

export { application }

