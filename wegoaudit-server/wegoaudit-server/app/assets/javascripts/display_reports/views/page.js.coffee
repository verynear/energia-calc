class DisplayReports.Views.Page extends Backbone.View
  events:
    'focus .js-contentblock-textarea': '_focusPreview'

  initialize: (options = {}) ->
    @$markdownEditorEl = $(options.markdownEditorEl)
    @$markdownPreviewEl = $(options.markdownPreviewEl)
    @photos = options.photos
    @previewUrl = options.preview_url
    @formHtml = options.formHtml

  render: ->
    editor = new DisplayReports.Views.Editor(
      model: @model
      el: @$markdownEditorEl
      previewUrl: @previewUrl
      photos: @photos
      formHtml: @formHtml
    )
    editor.render()

    preview = new DisplayReports.Views.Preview(
      model: @model
      el: @$markdownPreviewEl
    )
    preview.render()
    @$el

  _focusPreview: (event) ->
    contentblockName = $(event.currentTarget).data('contentblock-name')
    contentblock = $("span[data-contentblock-name='#{contentblockName}']")[0]
    if contentblock
      $(contentblock).get(0).scrollIntoView()

