import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  hide(event) {
    event.preventDefault()
    this.element.classList.add("hidden")
  }
}
