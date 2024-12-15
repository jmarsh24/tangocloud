import { Controller } from "@hotwired/stimulus";
import { patch } from "@rails/request.js";
import Sortable from "sortablejs";

export default class extends Controller {
  static values = { url: String, section: String };

  connect() {
    this.sortable = Sortable.create(this.element, {
      animation: 150,
      handle: "[data-sortable-handle]",
      ghostClass: "hidden-ghost",
      group: "shared",
      onEnd: this.onEnd.bind(this),
    });
  }

  disconnect() {
    this.sortable.destroy();
  }

  onEnd(event) {
    const { newIndex, item, to } = event;
    const id = item.dataset.sortableId;
    const newSection = to.dataset.sortableSection;
    const url = this.urlValue.replace(":id", id);

    patch(url, {
      body: JSON.stringify({ position: newIndex, section: newSection }),
    });
  }
}