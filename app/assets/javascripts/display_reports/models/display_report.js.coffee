class DisplayReports.Models.DisplayReport extends Backbone.RelationalModel
  defaults:
    markdown: ''

  relations: [{
    type: Backbone.HasMany,
    key: 'photos',
    relatedModel: 'DisplayReports.Models.Photo',
    collectionType: 'DisplayReports.Collections.Photos',
    reverseRelation: {
      key: 'display_report'
    }
  }]

DisplayReports.Models.DisplayReport.setup()
