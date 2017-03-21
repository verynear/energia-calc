class DisplayReports.Views.Editor extends Backbone.View
  events:
    'keyup textarea': 'updatePreview'
    'change textarea': 'updatePreview'
    'change .js-template-select': 'updateForm'

  initialize: (options = {}) ->
    @formHtml = options.formHtml
    @previewUrl = options.previewUrl
    @changeQueue = []
    $(window).on('load resize', @_resizeEditor)

  render: ->
    @$form = @$('form')
    @$templateForm = @$('.js-template-form')
    photos = new DisplayReports.Views.Photos(collection: @model.get('photos'))
    @$templateForm.append(photos.render())
    @$templateForm.append(@formHtml)
    @_resizeEditor()
    @$el

  updateForm: ->
    $.ajax(
      url: "/audit_reports/#{@model.get('id')}/display/change_template"
      data:
        audit_report:
          report_template_id: $('.js-template-select').val()
      method: 'PUT'
      success: (data) ->
        $('.js-template-form').html(data.form)
        $('.js-markdown-preview').html(data.preview)
    )

  updatePreview: ->
    @changeQueue.push(@$form.serialize())
    @_processQueue(true) unless @processing

  _processQueue: (firstTime) =>
    if !firstTime && @changeQueue.length == 0
      @processing = false
      return
    else
      @processing = true

    # Throw away everything but the last item
    _(@changeQueue.length - 1).times => @changeQueue.shift()

    change = @changeQueue.pop()
    $.ajax(
      url: @previewUrl,
      data: change,
      method: 'PUT',
    )
      .always(=>
        # Follows heuristic that if you type one character you'll likely type
        # more
        if @changeQueue.length == 0 && !firstTime
          @processing = false
        else
          # start over if an event was added during the ajax request
          setTimeout(@_processQueue, 400, false)
      )
      .done((data) =>
        @model.set('rendered_html', data)
      )

  _resizeEditor: =>
    @$el.height($(window).height() - @$el.offset().top)
