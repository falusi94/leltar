# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Item = Backbone.Model.extend {

}

ItemCollection = Backbone.PageableCollection.extend {
  model: Item
  mode: 'server'
  url: '/items'
}

class MoreLinkCell extends Backgrid.UriCell


window.collection = new ItemCollection

columns = [
  {
    name: 'id'
    label: 'ID'
    cell: 'integer'
    editable: false
  },
  {
    name: 'name'
    label: 'Name'
    cell: 'string'
  },
  {
    name: 'description'
    label: 'Description'
    cell: 'string'
  },
  {
    name: 'purchase'
    label: 'Purchase'
    cell: 'date'
  },
  {
    name: 'last_check'
    label: 'Last check'
    cell: 'date'
  },
  {
    name: 'old_number'
    label: 'Old number'
    cell: 'integer'
  },
  {
    name: 'id'
    label: ''
    cell: MoreLinkCell
    editable: false
  },

]

window.grid = new Backgrid.Grid {
 columns: columns
 collection: window.collection
}

$ () ->

  $('#grid-container').append(window.grid.render().el)

  window.collection.fetch()



