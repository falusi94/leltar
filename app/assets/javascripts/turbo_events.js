var turboEvents = (function () {
  var module = {}

  module.closeActiveNavDropdown = function() {
    var navbar = UIkit.navbar('.main-navbar')
    var activeDropdown = navbar.getActive()
    if (!activeDropdown) { return }

    activeDropdown.$el.classList.remove('uk-open')
  }

  return module
}());

document.addEventListener('turbo:before-cache', turboEvents.closeActiveNavDropdown)
