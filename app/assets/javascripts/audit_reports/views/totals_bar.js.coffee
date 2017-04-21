class AuditReports.Views.TotalsBar extends Backbone.View
  tagName: 'section'
  className: 'totals js-totals is-default'

  events:
    'click .js-totals-toggle': 'onToggleTotal'

  template: _.template """
    <a href="#" class="totals__toggle js-totals-toggle">
      Totals <i class="icon-chevron-up-small"></i>
    </a>
    <div class="totals__row totals__row--level1 js-totals-level1">

      <div class="totals__item"
           data-audit-report-calculation='cost_of_measure'>
        <div class="totals__label">Estimated Cost</div>
        <div class="totals__value"><%= cost_of_measure %></div>
      </div>

      <div class="totals__item"
           data-audit-report-calculation='annual_cost_savings'>
        <div class="totals__label">Annual Dollar Savings</div>
        <div class="totals__value"><%= annual_cost_savings %></div>
      </div>

      <div class="totals__item"
           data-audit-report-calculation='annual_energy_savings'>
        <div class="totals__label">Annual Energy Usage Reduction (btu)</div>
        <div class="totals__value"><%= annual_energy_savings %></div>
      </div>

      <div class="totals__item"
           data-audit-report-calculation='annual_water_savings'>
        <div class="totals__label">Annual Water Usage Reduction (gallons)</div>
        <div class="totals__value"><%= annual_water_savings %></div>
      </div>

      <div class="totals__item"
           data-audit-report-calculation='years_to_payback'>
        <div class="totals__label">Years to Payback</div>
        <div class="totals__value"><%= years_to_payback %></div>
      </div>

      <div class="totals__item"
           data-audit-report-calculation='utility_rebate'>
        <div class="totals__label">Utility Rebate </div>
        <div class="totals__value"><%= utility_rebate %></div>
      </div>

    </div>
    <div class="totals__row totals__row--level2 js-totals-level2">
    </div>
  """

  initialize: ->
    @model.on(
      'change',
      () =>
        @render()
        @postRender()
    )

  render: ->
    @$el.html(@template(@model.attributes))
    @$el.css('transform', 'translateY(69px)')
    @$el

  # Contains calculations that can only be done after the element is in the DOM
  postRender: ->
    @$totalsToggle = $('.js-totals-toggle')
    @$totalsLevel1 = $('.js-totals-level1')
    @$totalsLevel2 = $('.js-totals-level2')

    @totalsHeight = @$el.outerHeight()
    @totalsLevel1Height = @$totalsLevel1.outerHeight()
    @totalsLevel2Height = @$totalsLevel2.outerHeight()

    $('body').css('padding-bottom', @totalsHeight + 20)

    @stateDefault = "translateY(#{@totalsLevel2Height})"
    @stateExpanded = 'translateY(0)'
    @stateCollapsed =
      "translateY(#{ @totalsLevel2Height + @totalsLevel1Height - 4 }px)"

    @setCollapsedState()

  setCollapsedState: ->
    storedState = localStorage.getItem('panelState')
    if storedState
      if localStorage.getItem('panelState') == 'default'
        @$el.css({transform: @stateDefault})
      else
        @$el.css({transform: @stateCollapsed}).addClass('is-collapsed')
    else
      @$el.css({transform: @stateDefault})

  onToggleTotal: (event) ->
    event.preventDefault()
    if localStorage.getItem('panelState') == 'default'
      @$el.css({transform: @stateCollapsed}).addClass('is-collapsed')
      localStorage.setItem('panelState', 'collapsed')
    else
      @$el.css({transform: @stateDefault}).removeClass('is-collapsed')
      localStorage.setItem('panelState', 'default')
