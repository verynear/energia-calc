class AuditReports.Views.StructureCard extends Backbone.View
  tagName: 'div'
  className: 'structure__card'

  template: _.template """
    <form class="structure__form">
      <div class="row js-name-row">
      </div>
      <a href="#" class="structure__details" data-trigger="collapse">
        Details
      </a>
      <div class="collapsible js-fields-section">
      </div>
    </form>
  """

  initialize: (options = {}) ->
    @original = options.original ? true

    if @original
      @$el.addClass('js-original-structure')
    else
      @$el.addClass('js-proposed-structure')

  render: ->
    html = @template(
      structureLabel: "#{@model.get('name')}"
    )
    @$el.html(html)

    @_addNameField()
    @_addQuantityField() if @model.get('multiple')

    @$fieldsSection = @$('.js-fields-section')
    @_renderOriginalStructureFields()
    @_renderFields()
    @$el

  _addNameField: ->
    nameField = new AuditReports.Views.NameField(
      model: @model.get('name_field_value'))
    @$('.js-name-row').append(nameField.render())

  _addQuantityField: ->
    quantityField = new AuditReports.Views.QuantityField(
      original: @original
      model: @model.get('quantity_field_value'))
    @$('.js-name-row').append(quantityField.render())

  _renderFields: ->
    $row = null
    count = 0
    @model.get('field_values').each (fieldValue, index) =>
      field = new AuditReports.Views.Field(model: fieldValue)
      if count % 2 == 0
        $row = $("<div class='row'></div>")
        @$fieldsSection.append($row)
      $row.append(field.render())
      count += 1

  _renderOriginalStructureFields: ->
    @model.get('original_structure_field_values').each (fieldValue) =>
      $row = $("<div class='row'></div>")
      @$fieldsSection.append($row)
      field = new AuditReports.Views.OriginalStructureField(model: fieldValue)
      $row.append(field.render())
      staticField = new AuditReports.Views.EffectiveStructureField(
        model: fieldValue,
        name: "Effective #{fieldValue.get('name')}"
      )
      $row.append(staticField.render())
