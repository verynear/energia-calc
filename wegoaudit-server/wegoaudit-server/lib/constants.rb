module WegoAudit
  BASE_URL =
    case Rails.env
    when 'production' then 'https://wegoaudit.wegowise.com/'
    when 'staging' then 'https://wegoaudit-staging.wegowise.com/'
    when 'development' then "http://#{ENV['WEGOAUDIT_LOCAL_IP']}:9292"
    when 'test' then "http://example.com"
    end
end
