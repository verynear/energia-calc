class AuditReports.Models.FieldValue extends Backbone.RelationalModel
  defaults:
    id: ''
    name: ''
    api_name: ''
    value: ''
    value_type: ''
    from_audit: false

  get_default_value: =>
    value = @get('default')
    return value if typeof value in ['number', 'string']

    if @get('calc_structure').get('proposed')
      value.proposed
    else
      value.existing

AuditReports.Models.FieldValue.setup()
