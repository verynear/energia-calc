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

    @_addNameCalcField()
    @_addQuantityCalcField() if @model.get('multiple')

    @$fieldsSection = @$('.js-calc-fields-section')
    @_renderOriginalStructureFields()
    @_renderCalcFields()
    @$el

  _addNameCalcField: ->
    nameCalcField = new AuditReports.Views.NameCalcField(
      model: @model.get('name_calc_field_value'))
    @$('.js-name-row').append(nameCalcField.render())

  _addQuantityCalcField: ->
    quantityCalcField = new AuditReports.Views.QuantityCalcField(
      original: @original
      model: @model.get('quantity_calc_field_value'))
    @$('.js-name-row').append(quantityCalcField.render())

  _renderCalcFields: ->
    $row = null
    count = 0
    @model.get('calc_field_values').each (calcFieldValue, index) =>
      calc_field = new AuditReports.Views.CalcField(model: calcFieldValue)
      if count % 2 == 0
        $row = $("<div class='row'></div>")
        @$fieldsSection.append($row)
      $row.append(calc_field.render())
      count += 1

  _renderOriginalStructureFields: ->
    @model.get('original_structure_field_values').each (calcFieldValue) =>
      $row = $("<div class='row'></div>")
      @$fieldsSection.append($row)
      calc_field = new AuditReports.Views.OriginalStructureField(model: calcFieldValue)
      $row.append(calc_field.render())
      staticCalcField = new AuditReports.Views.EffectiveStructureCalcField(
        model: calcFieldValue,
        name: "Effective #{calcFieldValue.get('name')}"
      )
      $row.append(staticCalcField.render())
