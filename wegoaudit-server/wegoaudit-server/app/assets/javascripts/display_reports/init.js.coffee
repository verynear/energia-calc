window.DisplayReports =
  Views: {}
  Models: {}
  EventBus: _.extend({}, Backbone.Events)
  Collections: {}
  generate: (params) -> new DisplayReports.Generator(params)
