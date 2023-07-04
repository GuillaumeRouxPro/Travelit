import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("present")
    this.element.textContent = "Hello World!"
  }
}
