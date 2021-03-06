class AuditReports.Views.MeasuresManager extends Backbone.View
  events: {}

  template: _.template """
    <br><br><br>
    <ul class='measures-tabs js-sidebar-nav'>
    </ul>
    <div class="measure-wrapper js-active-content">
    </div>
  """

  initialize: (options = {}) ->
    @collection = @model.get('measure_selections')
    @listenTo(@collection, 'add', @addAndSelectMeasure)
    @listenTo(@collection, 'remove', @removeMeasure)

    @measureContents = []
    @measureTabs = []

  render: ->
    @$el.html(@template())
    @$sidebarNav = @$('.js-sidebar-nav')
    @$activeContent = @$('.js-active-content')

    @collection.each @addMeasure
    @setFirstMeasureActive()
    @$el

  addMeasure: (measure) =>
    measureContent = new AuditReports.Views.MeasureContent(model: measure)
    @measureContents.push(measureContent)
    $measureContent = measureContent.render()
    @$activeContent.append($measureContent)

    measureTab = new AuditReports.Views.MeasureTab(model: measure)
    @measureTabs.push(measureTab)
    $measureTab = measureTab.render()
    @$sidebarNav.append($measureTab)
    @$sidebarNav.sortable()

  addAndSelectMeasure: (measure) ->
    @addMeasure(measure)
    @collection.setActive(measure)

  removeMeasure: (measure) ->
    measureContent = _(@measureContents).find (content) ->
      content.model.id == measure.id
    @measureContents = _(@measureContents).reject (content) ->
      content == measureContent
    measureContent.remove()

    measureTab = _(@measureTabs).find (tab) ->
      tab.model.id == measure.id
    @measureTabs = _(@measureTabs).reject (tab) ->
      tab == measureTab
    measureTab.remove()

    @setFirstMeasureActive()

  setFirstMeasureActive: ->
    unless @collection.length == 0
      firstMeasure = @collection.at(0)
      @collection.setActive(firstMeasure)
