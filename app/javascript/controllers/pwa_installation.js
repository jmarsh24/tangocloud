import { Controller } from '@hotwired/stimulus';

let installPromptEvent;

window.addEventListener('beforeinstallprompt', async (event) => {
  event.preventDefault();

  installPromptEvent = event;
});

export default class extends Controller {
  async install(event) {
    if (!installPromptEvent) {
      return;
    }
    const result = await installPromptEvent.prompt();
    console.log(`Install prompt was: ${result.outcome}`);  // 'accepted' or 'dismissed'

    installPromptEvent = null;

    event.target.disabled = true;
  }
}
