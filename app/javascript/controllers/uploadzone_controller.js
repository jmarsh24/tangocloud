import { Controller } from "@hotwired/stimulus";
import { DirectUpload } from "@rails/activestorage";
import { post } from "@rails/request.js";

class Upload {
  constructor(file) {
    this.directUpload = new DirectUpload(
      file,
      "/rails/active_storage/direct_uploads",
      this
    );
  }

  process() {
    this.insertUpload();

    this.directUpload.create((error, blob) => this.createTrack(error, blob));
  }

  async createTrack(error, blob) {
    if (error) {
      // Handle the error
    } else {
      const trackData = {
        track: { filename: blob.filename },
        signed_blob_id: blob.signed_id,
      };

      const trackResponse = await post("/tracks", {
        body: trackData,
        contentType: "application/json",
        responseKind: "json",
      });

      if (trackResponse.ok) {
        this.trackJSON = await trackResponse.json;

        this.insertAudio();
      }
    }
  }

  insertAudio() {
    // Create audio element
    const audio = document.createElement("audio");
    audio.controls = true;
    audio.src = this.trackJSON.audio_url;
    audio.classList.add("w-full");

    // Make the parent progressWrapper div taller
    this.progressBar.parentElement.classList.add("h-14");
    this.progressBar.parentElement.classList.remove("h-4");

    // Insert the audio tag and remove the progress bar.
    this.progressBar.parentElement.appendChild(audio);
    this.progressBar.remove();
  }

  insertUpload() {
    const fileUpload = document.createElement("div");

    fileUpload.id = `upload_${this.directUpload.id}`;
    fileUpload.className = "p-3 border-b";

    fileUpload.textContent = this.directUpload.file.name;

    const progressWrapper = document.createElement("div");
    progressWrapper.className =
      "relative h-4 overflow-hidden rounded-full bg-secondary w-[100%]";
    fileUpload.appendChild(progressWrapper);

    this.progressBar = document.createElement("div");
    this.progressBar.className = "progress h-full w-full flex-1 bg-primary";
    this.progressBar.style = "transform: translateX(-100%);";
    progressWrapper.appendChild(this.progressBar);

    const uploadList = document.querySelector("#uploads");
    uploadList.appendChild(fileUpload);
  }

  directUploadWillStoreFileWithXHR(request) {
    request.upload.addEventListener("progress", (event) =>
      this.updateProgress(event)
    );
  }

  updateProgress(event) {
    const percentage = (event.loaded / event.total) * 100;
    const progress = document.querySelector(
      `#upload_${this.directUpload.id} .progress`
    );
    progress.style.transform = `translateX(-${100 - percentage}%)`;
  }
}

export default class extends Controller {
  static targets = ["fileInput"];
  connect() {
    this.element.addEventListener("dragover", this.preventDragDefaults);
    this.element.addEventListener("dragenter", this.preventDragDefaults);
  }

  disconnect() {
    this.element.removeEventListener("dragover", this.preventDragDefaults);
    this.element.removeEventListener("dragenter", this.preventDragDefaults);
  }

  preventDragDefaults(e) {
    e.preventDefault();
    e.stopPropagation();
  }

  trigger() {
    this.fileInputTarget.click();
  }

  acceptFiles(event) {
    event.preventDefault();
    const files = event.dataTransfer
      ? event.dataTransfer.files
      : event.target.files;
    [...files].forEach((f) => {
      new Upload(f).process();
    });
  }
}
