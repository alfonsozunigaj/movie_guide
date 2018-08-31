// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require jquery3
//= require popper
//= require bootstrap

function showReview() {
    var review_frame = document.getElementById("review_frame");
    var show_review_button = document.getElementById("show_review_button");
    if (review_frame.hidden) {
        review_frame.hidden = false;
        show_review_button.textContent = "Hide review";
    } else {
        review_frame.hidden = true;
        show_review_button.textContent = "Read the full review";
    }
}
