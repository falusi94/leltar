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
  getUri: (id) -> '/items/'+id
  render: () ->
    this.$el.empty()
    uri = this.getUri(this.model.get(this.column.get('name')))
    this.$el.html('<a href="'+uri+'">More</a>')
    this.delegateEvents()
    this

class ImageCell extends Backgrid.Cell
  render: () ->
    this.$el.empty()
    uri = this.model.get(this.column.get('name'))
    this.$el.html('<img src="'+uri+'"/>')
    this.delegateEvents()
    this

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
    name: 'group'
    label: 'Group'
    cell: 'string'
  },
  {
    name: 'purchase_date'
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
    name: 'thumb'
    label: ''
    cell: ImageCell
  },
  {
    name: 'id'
    label: ''
    cell: MoreLinkCell
    editable: false
  },

]

loadData = () ->
  reqParams = {}
  if window.itemFilter
    reqParams.filter = window.itemFilter
  if window.group
    reqParams.group = window.group
    $('#filter-field').val(window.itemFilter)
  window.collection.fetch(data: reqParams)

setFilter = () ->
  window.itemFilter = $('#filter-field').val()
  loadData()

ready =  () ->
  gridContainer = $('#grid-container')
  if gridContainer.length > 0
    collection = new ItemCollection
    window.collection = collection
    grid = new Backgrid.Grid {
     columns: columns
     collection: collection
    }
    gridContainer.html(grid.render().el)
    collection.on 'change', (model, options) ->
      model.save()

    $('#filter-field').keypress (e) ->
      if e.which == 13
        setFilter()

    $('#filter').click () ->
      setFilter()

    $('.first-page-link').click () ->
      collection.getFirstPage()
    $('.prev-page-link').click () ->
      collection.getPreviousPage()
    $('.next-page-link').click () ->
      collection.getNextPage()
    $('.last-page-link').click () ->
      collection.getLastPage()
    $('.page-num').text(collection.state.currentPage)
    collection.on 'pageable:state:change', () ->
      console.log('asd')
      $('.page-num').text(collection.state.currentPage)
    
    grid.$el.addClass('table-striped')
    loadData()

$(document).on('turbolinks:load', ready)

