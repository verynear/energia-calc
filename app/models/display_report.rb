require 'redcarpet'
require 'liquid'

class DisplayReport < Generic::Strict
  attr_accessor :filename,
                :locals,
                :markdown,
                :registers

  def initialize(*)
    super
    self.locals ||= {}
    self.registers ||= {}

    Liquid::Template.register_tag('contentblock', LiquidTags::ContentBlock)
    Liquid::Template.register_tag('pagebreak', LiquidTags::PageBreak)
    Liquid::Template.register_tag('image', LiquidTags::Image)
    Liquid::Template.register_tag('usage_summary', LiquidTags::UsageSummary)
    Liquid::Template.register_tag('measures_list', LiquidTags::MeasuresList)
    Liquid::Template.register_tag(
      'nei_usage_summary',
      LiquidTags::NeiUsageSummary)
    Liquid::Template.register_tag(
      'recommendations_table',
      LiquidTags::RecommendationsTable)
    Liquid::Template.register_tag(
      'detailed_recommendations_list',
      LiquidTags::DetailedRecommendationsList)
    Liquid::Template.register_tag(
      'financial_summary',
      LiquidTags::FinancialSummary)
    Liquid::Template.register_tag(
      'health_and_safety_recommendations',
      LiquidTags::HealthAndSafetyRecommendations)
  end

  def formatted_report
    expanded_markdown.html_safe
  end
  memoize :formatted_report

  private

  def expanded_markdown
    Liquid::Template
      .parse(rendered_markdown)
      .render(
        locals.deep_stringify_keys,
        registers: registers
      )
  rescue Liquid::SyntaxError => _e
    # TODO: display an error here
    rendered_markdown
  end

  def rendered_markdown
    # needed to avoid escaping the contents of liquid tags
    liquid_tags = []
    intermediate = markdown.gsub(/\{\{.+?\}\}|\{%.+?%\}/m) do |match|
      liquid_tags << match
      'LIQUID_TAG'
    end
    rendered = renderer.render(intermediate)

    if registers[:mode] == 'active'
      liquid_tags
        .select { |tag| tag =~ /contentblock/ }
        .map { |tag| "<br><p>#{tag}</p><br /><br />" }
        .join("\n")
    else
      rendered.gsub('LIQUID_TAG').with_index { |_, index| liquid_tags[index] }
    end
  end

  def renderer
    Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      autolink: true,
      no_intra_emphasis: true
    )
  end
end
