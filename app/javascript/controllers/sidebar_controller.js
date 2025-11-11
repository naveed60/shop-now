import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "overlay"]

  connect() {
    this.isOpen = false
    this.boundCloseOnEscape = this.closeOnEscape.bind(this)
  }

  toggle() {
    this.isOpen ? this.close() : this.open()
  }

  open() {
    this.panelTarget.classList.remove("-translate-x-full")
    this.overlayTarget.classList.remove("opacity-0", "pointer-events-none")
    document.body.classList.add("overflow-hidden")
    document.addEventListener("keydown", this.boundCloseOnEscape)
    this.isOpen = true
  }

  close() {
    this.panelTarget.classList.add("-translate-x-full")
    this.overlayTarget.classList.add("opacity-0", "pointer-events-none")
    document.body.classList.remove("overflow-hidden")
    document.removeEventListener("keydown", this.boundCloseOnEscape)
    this.isOpen = false
  }

  closeOnEscape(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }
}
