import { Controller } from "@hotwired/stimulus";
import Typed from "typed.js";

// Connects to data-controller="typed"
export default class extends Controller {
  connect() {
    var typed = new Typed("#banner-text", {
      strings: ["Use AI to solve challenges.", "Code faster"],
      typeSpeed: 30,
    });
  }
}
