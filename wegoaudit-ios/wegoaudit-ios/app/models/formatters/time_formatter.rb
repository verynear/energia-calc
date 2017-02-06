class TimeFormatter
  def self.from_string(str)
    Time.iso8601(str.gsub(/\.\d{3}Z/, 'Z'))
  end
end
