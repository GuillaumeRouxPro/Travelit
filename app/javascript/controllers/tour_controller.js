import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tour"
export default class extends Controller {
  static targets = ["bookingList"];
  showBookingList() {
    this.bookingListTarget.style.display = this.bookingListTarget.style.display === "none" ? "" : "none";
  }
}
