export function setupTurboConfirm() {
  Turbo.setConfirmMethod((message, element) => {
    const dialog = document.getElementById("turbo-confirm");

    if (!dialog) {
      console.error("Turbo confirm dialog not found!");
      return Promise.resolve(false);
    }

    const button = findButton(element);

    setDialogTitle(dialog, button);

    setDialogMessage(dialog, message);

    dialog.showModal();

    return new Promise((resolve) => {
      dialog.addEventListener(
        "close",
        () => resolve(dialog.returnValue === "confirm"),
        { once: true }
      );
    });
  });
}

function findButton(element) {
  return element.tagName === "FORM"
    ? element.querySelector("button[data-turbo-confirm-title]")
    : element;
}

function setDialogTitle(dialog, button) {
  const title = button?.getAttribute("data-turbo-confirm-title") || "Confirmation";
  const titleElement = dialog.querySelector("h3");

  if (titleElement) {
    titleElement.textContent = title;
  } else {
    console.warn("Dialog title element not found!");
  }
}

function setDialogMessage(dialog, message) {
  const messageElement = dialog.querySelector("p");

  if (messageElement) {
    messageElement.innerHTML = message;
  } else {
    console.warn("Dialog message element not found!");
  }
}