import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="booking"
export default class extends Controller {
  static targets = ["showContent"];
  showDatepicker() {
    this.showContentTargets[0].style.display = "";
  }

  cancel() {
    this.showContentTargets[0].style.display = "none";
  }
}
