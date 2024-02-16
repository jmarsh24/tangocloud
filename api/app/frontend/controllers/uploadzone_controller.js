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
      console.error("Error in direct upload", error);
    } else {
      const audioTransferData = {
        audio_transfer: { filename: blob.filename },
        signed_blob_id: blob.signed_id,
      };

      const audioTransferResponse = await post("/audio_transfers", {
        body: JSON.stringify(audioTransferData),
        contentType: "application/json",
        responseKind: "json",
      });

      if (audioTransferResponse.ok) {
        this.audioTransferJSON = await audioTransferResponse.json;
        this.insertAudio();
      } else {
        this.audioTransferJSON = await audioTransferResponse.json;
        this.progressBar.classList.add("upload-progress-bar--error");
        this.insertErrorElement(this.audioTransferJSON.errors);
      }
    }
  }

  insertErrorElement(errors) {
    const errorMessage = document.createElement("div");
    errorMessage.className = "upload-error-message";
    // Assuming errors is an array of strings
    errorMessage.textContent = "Error: " + errors.join(", ");
    this.progressBar.parentElement.appendChild(errorMessage);
  }

  insertAudio() {
    const audio = document.createElement("audio");
    audio.controls = true;
    audio.src = this.audioTransferJSON.audio_url;
    audio.classList.add("audio-player");

    this.progressBar.parentElement.appendChild(audio);
  }

  insertUpload() {
    const fileUpload = document.createElement("div");
    fileUpload.id = `upload_${this.directUpload.id}`;
    fileUpload.className = "audio-upload-container";

    const filenameStrong = document.createElement("span");
    filenameStrong.textContent = this.directUpload.file.name;

    fileUpload.appendChild(filenameStrong);

    this.progressBar = document.createElement("div");
    this.progressBar.className = "upload-progress-bar";
    fileUpload.appendChild(this.progressBar);

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
