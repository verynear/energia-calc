class AuditReports.Views.MeasureSummary extends Backbone.View
  className: "js-measure-summary measure__summary"

  template: _.template """
    <div class="measure__summary__title">
      Measure Summary
    </div>

    <div class="js-measure-fields">
    </div>

    <div class="measure__summary__section-title">
      Overall usage values (before measure)
    </div>

    <div class="js-usage-values">
    </div>

    <div class="measure__summary__section-title">
      Calculation results
    </div>
  """

  render: =>
    @$el.html(@template())
    @$usageValues = @$('.js-usage-values')
    @$measureFieldsRow = @$('.js-measure-fields')

    @_renderMeasureFields()
    @_renderUsageValues()
    @_renderCalculatedValues()

    $row = $("<div class='row'></div>")
    @$el.append($row)

    descriptionField =
      new AuditReports.Views.DescriptionField(
        model: @model,
      )
    $row.append(descriptionField.render())
    recommendationField =
      new AuditReports.Views.RecommendationField(
        model: @model,
      )
    $row.append(recommendationField.render())
    @$el

  _renderCalculatedValues: ->
    calculatedValues =
      new AuditReports.Views.MeasureSummaryCalculatedValues(model: @model)
    @$el.append(calculatedValues.render())

  _renderMeasureFields: ->
    $row = null
    count = 0
    @model.get('field_values').each (fieldValue) =>
      if count % 4 == 0
        $row = $("<div class='row'></div>")
        @$measureFieldsRow.append($row)
      measureField = new AuditReports.Views.MeasureField(model: fieldValue)
      $row.append(measureField.render())
      count += 1

  _renderUsageValues: ->
    $row = null
    count = 0
    _(@model.get('before_usage_values')).each (options, key) =>
      if count % 4 == 0
        $row = $("<div class='row'></div>")
        @$usageValues.append($row)
      staticField = new AuditReports.Views.StaticField(
        name: options.title,
        value: options.value
      ).render()
      $row.append(staticField)
      count += 1
