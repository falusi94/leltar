# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Item = Backbone.Model.extend {

}

class ItemCollection extends Backbone.PageableCollection
  model: Item
  url: '/items'
  constructor: (pagemode) ->
    if pagemode == 'check'
      @mode = 'client'
    else
      @mode = 'server'
    this.state.pagesize = 2
    super()
  toJSON: ->
    {items: super()}


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
    this.$el.addClass('image-cell')
    this.delegateEvents()
    this

class CheckCell extends Backgrid.Cell
  render: () ->
    this.$el.empty()
    checkbox = $('<input type="checkbox">')
    this.$el.html(checkbox)
    this.delegateEvents()
    self = this
    checkbox.click () ->
     self.model.set('checked', this.checked)
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
    name: 'status'
    label: 'Status'
    cell: 'string'
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
    editable: false
  },
  {
    name: 'id'
    label: ''
    cell: MoreLinkCell
    editable: false
  },
]

checkPageColumns = [
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
    name: 'status'
    label: 'Status'
    cell: 'string'
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
    editable: false
  },
  {
    name: 'id'
    label: ''
    cell: CheckCell
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

pagemodeToggle = () ->
  if window.checkpage
    window.checkpage = false
  else
    window.checkpage = true
  ready()


checkmodeSave = (collection) ->
  today = new Date().toJSON().slice(0,10)
  collection.each (model, ix, collection) ->
    if model.get('checked')
      model.set('last_check', today)
  window.checkpage = false
  error = () ->
    $('.error-message').text('Hiba tortent, van internet?')
    $('.error-message').show()
  Backbone.sync('update', collection, {error: error, success: ready})

ready =  () ->
  gridContainer = $('#grid-container')
  if gridContainer.length > 0
    if window.checkpage
      pagemode = 'check'
    else
      pagemode = 'default'
    collection = new ItemCollection(pagemode)
    window.collection = collection
    if pagemode == 'default'
      grid = new Backgrid.Grid {
       columns: columns
       collection: collection
      }
    else
      grid = new Backgrid.Grid {
       columns: checkPageColumns
       collection: collection
      }
    gridContainer.html(grid.render().el)
    $('.error-message').hide()
    $('.first-page-link').off('click')
    $('.prev-page-link').off('click')
    $('.next-page-link').off('click')
    $('.last-page-link').off('click')
    $('.pagemode-toggle').off('click')
    $('.save-changes').off('click')
    $('#filter').off('click')
    $('#filter-field').off('keypress')
    $('.new-item-link').off('click')
    if pagemode == 'default'
      collection.on 'change', (model, options) ->
        model.save()
      #first deregister all previous event bindings
      $('#filter-field').keypress (e) ->
        if e.which == 13
          setFilter()
      $('#filter').click () ->
        setFilter()
      $('#filter-container').show()
      $('.pagemode-toggle').text('Checkmode')
      $('.save-changes').hide()
    else if pagemode == 'check'
      $('#filter-container').hide()
      $('.pagemode-toggle').text('Discard changes')
      $('.save-changes').show()
      $('.new-item-link').click () ->
        collection.add(new Item)
        false

    #deregister possible old events

    $('.first-page-link').click () ->
      collection.getFirstPage()
    $('.prev-page-link').click () ->
      collection.getPreviousPage()
    $('.next-page-link').click () ->
      collection.getNextPage()
    $('.last-page-link').click () ->
      collection.getLastPage()
    $('.pagemode-toggle').click pagemodeToggle
    $('.save-changes').click () ->
      checkmodeSave(collection)

    #pagenumber handling
    $('.page-num').text(collection.state.currentPage)
    collection.on 'pageable:state:change', () ->
      console.log('asd')
      $('.page-num').text(collection.state.currentPage)
    
    grid.$el.addClass('table-striped')
    loadData()

$(document).on('turbolinks:load', ready)

