import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="load"
export default class extends Controller {
  start(event) {
    const btn = event.currentTarget;
    btn.insertAdjacentHTML(
      "beforebegin",
      '<button class="btn btn-primary disabled"><i class="fa-solid fa-atom fa-spin-pulse"></i></button>',
    );
    btn.classList.add("d-none");
    // request submit
  }
}

// <i class="fa-solid fa-atom fa-spin-pulse"></i>
