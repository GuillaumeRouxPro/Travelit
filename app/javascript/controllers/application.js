import { Application } from "@hotwired/stimulus"

//= require select2
$(document).ready(function() {
  $('.select2').select2();
});




const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
