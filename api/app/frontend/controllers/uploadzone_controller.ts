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

    this.directUpload.create((error, blob) =>
      this.createAudioTransfer(error, blob)
    );
  }

  async createAudioTransfer(error, blob) {
    if (error) {
      // Handle the error
    } else {
      const audioTransferData = {
        audio_transfer: { filename: blob.filename },
        signed_blob_id: blob.signed_id,
      };

      const audioTransferResponse = await post("/audio_transfers", {
        body: audioTransferData,
        contentType: "application/json",
        responseKind: "json",
      });

      if (audioTransferResponse.ok) {
        this.audioTransferJSON = await audioTransferResponse.json;

        this.insertAudio();
      }
    }
  }

  insertAudio() {
    const audio = document.createElement("audio");
    audio.controls = true;
    audio.src = this.audioTransferJSON.audio_url;
    audio.classList.add("audio-player");

    // this.progressBar.parentElement.classList.add("progress-wrapper-expanded");
    // this.progressBar.parentElement.classList.remove("progress-wrapper");

    this.progressBar.parentElement.appendChild(audio);
    // this.progressBar.remove();
  }

  insertUpload() {
    const fileUpload = document.createElement("div");

    fileUpload.id = `upload_${this.directUpload.id}`;
    fileUpload.className = "audio-upload-container";

    fileUpload.textContent = this.directUpload.file.name;

    const progressWrapper = document.createElement("div");
    progressWrapper.className = "progress-wrapper";
    fileUpload.appendChild(progressWrapper);

    this.progressBar = document.createElement("div");
    this.progressBar.className = "upload-progress-bar";
    progressWrapper.appendChild(this.progressBar);

    const uploadList = document.querySelector("#uploads");
    uploadList.appendChild(fileUpload);
  }

  directUploadWillStoreFileWithXHR(request) {
    request.upload.addEventListener("progress", (event) => {
      this.updateProgress(event);
    });
  }

  updateProgress(event) {
    const percentage = (event.loaded / event.total) * 100;
    const progress = document.querySelector(
      `#upload_${this.directUpload.id} .upload-progress-bar`
    );
    progress.style.width = `${percentage}%`;
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
