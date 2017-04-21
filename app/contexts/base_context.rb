class BaseContext < Generic::Strict
  delegate :url_helpers, to: 'Rails.application.routes'
end
