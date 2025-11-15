import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "modal",
    "image",
    "title",
    "description",
    "badge",
    "hero",
    "rating",
    "price",
    "originalPrice",
    "discount",
    "stock",
    "colors",
    "link"
  ]

  connect() {
    this.boundCloseOnEscape = this.closeOnEscape.bind(this)
  }

  open(event) {
    if (event.type === "keydown") {
      this.openWithKeyboard(event)
      return
    }

    this.populateFrom(event.currentTarget)
    this.showModal()
  }

  openWithKeyboard(event) {
    if (event.key !== "Enter" && event.key !== " ") return
    event.preventDefault()
    this.populateFrom(event.currentTarget)
    this.showModal()
  }

  close() {
    if (!this.hasModalTarget) return
    this.modalTarget.classList.add("hidden")
    this.modalTarget.classList.remove("flex")
    document.body.classList.remove("overflow-hidden")
    window.removeEventListener("keydown", this.boundCloseOnEscape)
  }

  stop(event) {
    event.stopPropagation()
  }

  closeOnEscape(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  populateFrom(card) {
    const data = card.dataset
    this.titleTarget.textContent = data.productModalName || ""
    this.descriptionTarget.textContent = data.productModalDescription || ""
    this.badgeTarget.textContent = data.productModalBadge || ""
    this.heroTarget.textContent = data.productModalHero || ""
    this.ratingTarget.textContent = data.productModalRating || ""
    this.priceTarget.textContent = data.productModalPrice || ""
    this.originalPriceTarget.textContent = data.productModalOriginalPrice || ""
    this.discountTarget.textContent = data.productModalDiscount || ""
    this.stockTarget.textContent = data.productModalStock || ""

    const imageUrl = data.productModalImage || ""
    if (imageUrl.length > 0) {
      this.imageTarget.src = imageUrl
      this.imageTarget.classList.remove("opacity-0")
    } else {
      this.imageTarget.src = ""
      this.imageTarget.classList.add("opacity-0")
    }
    this.imageTarget.alt = data.productModalName || "Product image"

    const colors = (data.productModalColors || "")
      .split(",")
      .map((color) => color.trim())
      .filter(Boolean)
    this.colorsTarget.innerHTML = ""
    if (colors.length) {
      colors.forEach((color) => {
        const swatch = document.createElement("span")
        swatch.className = "h-6 w-6 rounded-full border border-white shadow ring-1 ring-slate-200"
        swatch.style.backgroundColor = color
        swatch.title = color
        this.colorsTarget.appendChild(swatch)
      })
    } else {
      const placeholder = document.createElement("p")
      placeholder.className = "text-xs text-slate-400"
      placeholder.textContent = "No swatches available"
      this.colorsTarget.appendChild(placeholder)
    }

    if (this.hasLinkTarget) {
      const url = data.productModalUrl || "#"
      this.linkTarget.href = url
    }
  }

  showModal() {
    if (!this.hasModalTarget) return
    this.modalTarget.classList.remove("hidden")
    this.modalTarget.classList.add("flex")
    document.body.classList.add("overflow-hidden")
    window.addEventListener("keydown", this.boundCloseOnEscape)
  }
}
