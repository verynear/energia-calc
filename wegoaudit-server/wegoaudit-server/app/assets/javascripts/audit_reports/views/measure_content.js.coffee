class AuditReports.Views.MeasureContent extends Backbone.View
  className: 'js-measure-content measure'

  template: _.template """
    <div class="measure__actions">
      <span
        class="measure__action"
        data-trigger='tooltip'
        data-content='Add or remove this measure from calculations'>
        <input
          type='checkbox'
          <%= checked %>
          name='enable-measure'
          class='js-enable-measure-checkbox'>
      </span>
      <a href='#'
        class='measure__action js-delete-measure-link'
        rel='nofollow'
        data-trigger='tooltip'
        data-content='Delete this measure'>
        <i class="icon-trash"></i>
      <a>
      <a href="#"
        class='measure__action js-add-calc-structure-link'
        data-trigger='tooltip'
        data-content='Add a new structure to this measure'>
        <i class="icon-plus"></i>
      </a>
    </div>
  """

  notesTemplate: _.template """
    <p>Notes: <%= notes %></p>
  """

  noCalcStructuresTemplate: _.template """
    <div class="measure__empty">
      <a href='#' class='js-add-calc-structure-link'>Add a structure</a> to get
      started.
    </div>
  """

  events:
    'click .js-add-calc-structure-link': 'onClickAddCalcStructure'
    'click .js-delete-measure-link': 'onClickDeleteMeasure'
    'change .js-enable-measure-checkbox': 'onChangeEnableMeasure'

  initialize: (options = {}) ->
    @listenTo(@model, 'change:active', @render)
    @listenTo(@model.get('structure_changes'), 'remove', @render)
    @listenTo(@model.get('structure_changes'), 'add', @render)

  render: =>
    @$el.html @template(
      checked: if @model.get('enabled') then 'checked' else ''
    )

    if @model.get('structure_changes').isEmpty()
      @$el.append @noCalcStructuresTemplate()
    else
      @_renderStructureChanges()
      @_renderMeasureSummary()

    measureNotes = @model.get('notes')
    if measureNotes
      @$el.append @notesTemplate(notes: measureNotes)

    if @model.get('active')
      @$el.show()
    else
      @$el.hide()

    @$el

  measureSelectionUrl: () ->
    report_id = @model.get('report_id')
    id = @model.get('id')
    "/calc/audit_reports/#{report_id}/measure_selections/#{id}"

  onClickAddCalcStructure: (event) ->
    event.preventDefault()
    url = "/calc/measure_selections/#{@model.get('id')}/structure_changes/new"
    modal = new AuditReports.Views.AddStructureChangeModal(
      collection: @model.get('structure_changes')
      model: @model
      url: url)
    modal.render()

  onClickDeleteMeasure: (event) ->
    event.preventDefault()

    if confirm('Are you sure you want to delete this measure?')
      $.ajax(
        url: @measureSelectionUrl(),
        type: 'DELETE',
        success: (data) =>
          @model.collection.remove(@model)
          triggerAuditReportSummary(data)
      )

  onChangeEnableMeasure: (event) ->
    @model.toggleEnabled()

    $.ajax(
      method: 'PUT'
      url: @measureSelectionUrl()
      data:
        measure_selection:
          enabled: @model.get('enabled')
      success: (data) ->
        triggerAuditReportSummary(data)
    )

  _renderStructureChanges: ->
    @model.get('structure_changes').each (structureChange, index) =>
      @$el.append(
        new AuditReports.Views.StructureChange(
          index: index,
          model: structureChange
        ).render()
      )
    @$el

  _renderMeasureSummary: ->
    measureSummary = new AuditReports.Views.MeasureSummary(
      model: @model.get('measure_summary')
    )
    @$el.append(measureSummary.render())

    measurePhotos = new AuditReports.Views.MeasurePhotos(
      collection: @model.get('photos')
    )
    @$el.append(measurePhotos.render())
