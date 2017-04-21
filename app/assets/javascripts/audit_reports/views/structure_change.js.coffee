class AuditReports.Views.StructureChange extends Backbone.View
  events:
    'click .js-delete-structure-change': 'deleteStructureChange'

  tagName: 'div'
  className: 'structure'
  template: _.template """
    <div class='structure__change'>
      <div class='structure__title'>
        <%= index %> - <%= structureTypeName  %>
      </div>
      <a href="#"
         class="structure__change__delete
                js-delete-structure-change"
         data-trigger="tooltip"
         data-content="Delete this structure pair">
          <i class="icon-close-solid"></i>
      </a>

      <div class="structure__column
                  structure__column--original
                  js-original-structures-column">
        <div class="structure__column__title">
          Original
        </div>
      </div>

      <div class="structure__column
                  structure__column--proposed
                  js-proposed-structures-column">
        <div class="structure__column__title">
          Proposed
        </div>
      </div>
    </div>
  """

  initialize: (options = {}) ->
    { @index } = options
    @originalStructureCard = new AuditReports.Views.StructureCard(
      original: true
      model: @model.get('original_structure')
    )
    @proposedStructureCard = new AuditReports.Views.StructureCard(
      original: false
      model: @model.get('proposed_structure')
    )

  render: ->
    html = @template(
      index: @index + 1
      structureTypeName: @model.get('structure_type_name')
    )
    @$el.html(html)
    @$originalStructuresColumn = @$('.js-original-structures-column')
    @$originalStructuresColumn.append(@originalStructureCard.render())
    @$proposedStructuresColumn = @$('.js-proposed-structures-column')
    @$proposedStructuresColumn.append(@proposedStructureCard.render())
    @$el

  deleteStructureChange: (event) ->
    event.preventDefault()
    $.ajax(
      method: 'DELETE'
      url: @structureChangeUrl()
      success: (data) =>
        @model.get('measure_selection')
          .get('structure_changes')
          .remove(@model)
        $('.tooltip').hide()
        @remove()
        triggerAuditReportSummary(data)
    )

  structureChangeUrl: ->
    measure_selection_id = this.model.get('measure_selection').get('id')
    id = @model.get('id')
    "/calc/measure_selections/#{measure_selection_id}/structure_changes/#{id}"
