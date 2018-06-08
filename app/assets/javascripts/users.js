var user = (function () {
  var module = {};

  module.init = function() {
    var adminCheckbox = document.getElementById('user_admin');
    if (!adminCheckbox) { return; }

    adminCheckbox.onchange = updateCheckboxes;
    updateCheckboxes();
  }

  function updateCheckboxes() {
    var readCheckbox = document.getElementById('user_read_all_group');
    var writeCheckbox = document.getElementById('user_write_all_group');
    var adminCheckbox = document.getElementById('user_admin');

    if (adminCheckbox.checked) {
      readCheckbox.checked = true;
      writeCheckbox.checked = true;
      readCheckbox.disabled = true;
      writeCheckbox.disabled = true;
    } else {
      readCheckbox.disabled = false;
      writeCheckbox.disabled = false;
    }
  }

  return module;
}());

$(document).ready(user.init);
