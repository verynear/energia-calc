class AuditReports.Models.OriginalStructureFieldValue extends Backbone.RelationalModel
  defaults:
    id: ''
    real_id: ''
    name: ''
    api_name: ''
    effective_value: ''
    value: ''
    value_type: ''
    from_audit: false

  initialize: ->
    @listenTo(AuditReports.EventBus,
      "channel:effective_structure_values",
      @_listenForEffectiveStructureChange
    )

    @listenTo(AuditReports.EventBus,
      "channel:original_structure_field_value:#{@get('real_id')}",
      @_listenForOriginalStructureChange
    )

  _listenForEffectiveStructureChange: (args) =>
    [event, data] = args
    effectiveValues =
      data[@get('measure_selection_id')][@get('structure_wegoaudit_id')]
    effectiveValue = effectiveValues[@get('api_name')]
    @set('effective_value', effectiveValue)

  _listenForOriginalStructureChange: (args) =>
    [event, data] = args
    @set('value', data)

AuditReports.Models.OriginalStructureFieldValue.setup()
