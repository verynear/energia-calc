class window.Modal extends Backbone.View
  events:
    'click .js-modal-close': 'onClickClose'
    'submit form': 'submitForm'

  template: _.template """
    <div class='js-modal modal'>
    </div>
  """

  initialize: (options = {}) ->
    @url = options.url

  render: ->
    if $('.js-modal').length != 0
      @setElement($('.js-modal'))
      @$el.html('')
    else
      @setElement(@template())
      $('body').append(@$el)

    @$el.easyModal
      # you have wait till the modal has been closed...but there is no onClosed :(
      # onClose: () => @remove()
      overlay: 0.2
      transitionIn: 'slidein'
      transitionOut: 'slideout'
      autoOpen: true

    $.ajax(
      url: @url,
      method: 'GET',
      success: (data) =>
        @$el.html(data)
        @$el.trigger('openModal')
        @afterLoad()
    )

  afterLoad: ->
    # noop

  submitForm: (event) ->
    # noop

  onClickClose: ->
    event.preventDefault()
    @$el.trigger('closeModal')
