class WegoAuditConfig
  def [](key)
    return if key.nil?
    NSBundle.mainBundle.objectForInfoDictionaryKey(key.to_s)
  end
end
