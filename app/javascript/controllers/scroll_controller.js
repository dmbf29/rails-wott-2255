import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="scroll"
export default class extends Controller {
  connect() {
    // scroll this object into view
    // i dont have a target, i just want the object that the controller is on
    // console.log(this.element);
    this.element.scrollIntoView();
  }
}

// C -> Controller
// A -> Action
// T -> Target
