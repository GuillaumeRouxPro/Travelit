import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="booking"
export default class extends Controller {
  static targets = ["bookingList"];
  showBookingList() {
    this.bookingListTarget.style.display = this.bookingListTarget.style.display === "none" ? "" : "none";
  }
}
