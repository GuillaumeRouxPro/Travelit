import { Controller } from "@hotwired/stimulus";


export default class extends Controller {
  static targets = ["bookingList"];

  connect() {
    console.log('Booking Controller connected');
  }


  showBookingList() {
    this.bookingListTarget.style.display = "block";
  }
}
