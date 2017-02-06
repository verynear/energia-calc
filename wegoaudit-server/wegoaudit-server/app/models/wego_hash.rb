class WegoHash < Decorator
  DEFAULT_CONVERSIONS = { id: :wegowise_id,
                          type: :object_type }.with_indifferent_access

  def initialize(params = {}, options = {})
    @conversions = options.with_indifferent_access.fetch(:conversions, {})
                          .merge(DEFAULT_CONVERSIONS)

    @component = params.with_indifferent_access
    rename_keys(@component)
  end

  def flatten(options = {})
    without_prefix = Array(options.with_indifferent_access
                                  .fetch('without_prefix', []))
                       .map { |exclude_prefix| exclude_prefix.to_s }
    @component = flatten_hash(self, nil, without_prefix)
  end

  def add_conversions(new_conversions)
    @conversions = new_conversions.with_indifferent_access
                                  .merge(@conversions)
    rename_keys(@component)
  end

  private

  def rename_keys(hash)
    hash.keys.each do |key|
      if conversion_key = @conversions[key]
        hash[conversion_key] = hash.delete(key)
        next
      end
      rename_keys(hash[key]) if hash[key].kind_of?(Hash)
    end
    hash
  end

  def flatten_hash(hash, prefix = nil, without_prefix = [])
    hash.keys.each_with_object({}) do |key, new_hash|
      value = hash[key]
      new_key = [prefix, key].compact.join('_')
      if value.is_a?(Hash)
        new_key = nil if without_prefix.include?(key)
        flatten_hash(value, new_key, without_prefix).each do |f_key, f_value|
          new_hash[f_key] = f_value
        end
      else
        new_hash[new_key] = value
      end
    end
  end
end
