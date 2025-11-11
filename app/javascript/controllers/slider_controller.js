import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide", "indicator"]
  static values = {
    interval: { type: Number, default: 6000 }
  }

  connect() {
    this.index = 0
    this.show(this.index)
    this.start()
  }

  disconnect() {
    this.stop()
  }

  start() {
    this.stop()
    if (this.slideTargets.length > 1) {
      this.timer = setInterval(() => this.next(), this.intervalValue)
    }
  }

  stop() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  }

  pause() {
    this.stop()
  }

  resume() {
    this.start()
  }

  next() {
    this.index = (this.index + 1) % this.slideTargets.length
    this.show(this.index)
  }

  go(event) {
    const targetIndex = parseInt(event.params.index, 10)
    if (Number.isNaN(targetIndex)) return
    this.index = targetIndex
    this.show(this.index)
    this.start()
  }

  show(index) {
    this.slideTargets.forEach((element, idx) => {
      element.classList.toggle("hidden", idx !== index)
    })

    this.indicatorTargets.forEach((indicator, idx) => {
      indicator.classList.toggle("bg-white", idx === index)
      indicator.classList.toggle("opacity-100", idx === index)
      indicator.classList.toggle("opacity-50", idx !== index)
    })
  }
}
