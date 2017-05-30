class DisplayReports.Views.Preview extends Backbone.View
  initialize: ->
    @listenTo(@model, 'change:rendered_html', @render)
    @listenTo(document, 'resize', @_resizePreview)

  render: ->
    @$el.html(@model.get('rendered_html'))
    @_resizePreview()
    @$el

  _resizePreview: ->
    @$el.height($(window).height())
