# The classes that include this module represent objects from Wegoaudit that
# can be treated as value objects (their identities don't matter). To reduce
# queries we should retrieve them from memory after a one-time load per worker
# process.
#
module WegoauditObjectLookup
  def self.included(klass)
    klass.extend(ClassMethods)
    klass.include(Memoizer) # rubocop:disable Wego/ImplicitMemoizer
  end

  module ClassMethods
    include Memoizer # rubocop:disable Wego/ImplicitMemoizer

    def api_name_lookup
      all.to_a.reduce({}) do |hash, object|
        hash[object.api_name] = object
        hash
      end
    end
    memoize :api_name_lookup

    def by_api_name(name)
      api_name_lookup[name.to_s]
    end

    def by_api_name!(api_name)
      object = by_api_name(api_name)
      raise ArgumentError, "No #{name} with api_name #{api_name}" unless object
      object
    end
  end
end
