var items = (function () {
  var module = {};

  module.init = function() {
    var form = document.getElementById('search-form');
    form.onsubmit = function() {
      var split = form.action.split('/');
      if (split[split.length-1] != 'items') {
        split.pop();
        form.action = split.join('/');
      }
      return true;
    }
  }


  return module;
  }());

  $(document).ready(items.init);
