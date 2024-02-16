import { Controller } from "@hotwired/stimulus";
import { DirectUpload } from "@rails/activestorage";
import Dropzone from "dropzone";
import {
  getMetaValue,
  findElement,
  removeElement,
  insertAfter,
} from "./helpers";

Dropzone.autoDiscover = false;

export default class extends Controller {
  static targets = ["input"];
  dropZone: Dropzone;
  inputTarget: HTMLInputElement;
  submitButton: HTMLInputElement | HTMLButtonElement;

  connect(): void {
    console.log("Dropzone connected");
    this.dropZone = createDropZone(this);
    this.hideFileInput();
    this.bindEvents();
  }

  // Private
  hideFileInput(): void {
    this.inputTarget.disabled = true;
    this.inputTarget.style.display = "none";
  }

  bindEvents(): void {
    this.dropZone.on("addedfile", (file: Dropzone.DropzoneFile) => {
      setTimeout(() => {
        file.accepted && createDirectUploadController(this, file).start();
      }, 500);
    });

    this.dropZone.on("removedfile", (file: any) => {
      if (file.controller) removeElement(file.controller.hiddenInput);
    });

    this.dropZone.on("canceled", (file: any) => {
      if (file.controller) file.controller.xhr.abort();
    });

    this.dropZone.on("processing", (file: Dropzone.DropzoneFile) => {
      this.submitButton.disabled = true;
    });

    this.dropZone.on("queuecomplete", () => {
      this.submitButton.disabled = false;
    });
  }

  get headers(): Record<string, string> {
    return { "X-CSRF-Token": getMetaValue("csrf-token") };
  }

  get url(): string {
    return this.inputTarget.getAttribute("data-direct-upload-url") as string;
  }

  get maxFiles(): number {
    return parseInt(this.data.get("maxFiles") || "1");
  }

  get maxFileSize(): number {
    return parseInt(this.data.get("maxFileSize") || "256");
  }

  get acceptedFiles(): string {
    return this.data.get("acceptedFiles") || "";
  }

  get addRemoveLinks(): boolean {
    return this.data.get("addRemoveLinks") === "true";
  }

  get form(): HTMLFormElement {
    return this.element.closest("form") as HTMLFormElement;
  }
}

class DirectUploadController {
  directUpload: DirectUpload;
  source: any;
  file: Dropzone.DropzoneFile;
  hiddenInput: HTMLInputElement;
  xhr: XMLHttpRequest;

  constructor(source: any, file: Dropzone.DropzoneFile) {
    this.source = source;
    this.file = file;
    this.directUpload = createDirectUpload(file, source.url, this);
  }

  start(): void {
    this.file.controller = this;
    this.hiddenInput = this.createHiddenInput();
    this.directUpload.create(
      (error: Error, attributes: { signed_id: string }) => {
        if (error) {
          removeElement(this.hiddenInput);
          this.emitDropzoneError(error);
        } else {
          this.hiddenInput.value = attributes.signed_id;
          this.emitDropzoneSuccess();
        }
      }
    );
  }

  // Private
  createHiddenInput(): HTMLInputElement {
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = this.source.inputTarget.name;
    insertAfter(input, this.source.inputTarget);
    return input;
  }

  bindProgressEvent(xhr: XMLHttpRequest): void {
    this.xhr = xhr;
    xhr.upload.addEventListener("progress", (event) =>
      this.uploadRequestDidProgress(event)
    );
  }

  uploadRequestDidProgress(event: ProgressEvent): void {
    const progress = (event.loaded / event.total) * 100;
    findElement(this.file.previewTemplate, ".dz-upload").style.width =
      `${progress}%`;
  }

  emitDropzoneUploading(): void {
    this.file.status = Dropzone.UPLOADING;
    this.source.dropZone.emit("processing", this.file);
  }

  emitDropzoneError(error: Error): void {
    this.file.status = Dropzone.ERROR;
    this.source.dropZone.emit("error", this.file, error.toString());
    this.source.dropZone.emit("complete", this.file);
  }

  emitDropzoneSuccess(): void {
    this.file.status = Dropzone.SUCCESS;
    this.source.dropZone.emit("success", this.file);
    this.source.dropZone.emit("complete", this.file);
  }
}

// Top-level functions...
function createDirectUploadController(
  source: any,
  file: Dropzone.DropzoneFile
): DirectUploadController {
  return new DirectUploadController(source, file);
}

function createDirectUpload(
  file: File,
  url: string,
  controller: DirectUploadController
): DirectUpload {
  return new DirectUpload(file, url, controller);
}

function createDropZone(controller: any): Dropzone {
  return new Dropzone(controller.element, {
    url: controller.url,
    headers: controller.headers,
    maxFiles: controller.maxFiles,
    maxFilesize: controller.maxFileSize,
    acceptedFiles: controller.acceptedFiles,
    addRemoveLinks: controller.addRemoveLinks,
    autoQueue: false,
  });
}
