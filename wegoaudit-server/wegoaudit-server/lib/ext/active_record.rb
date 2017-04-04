require 'memoizer'

# rubocop:disable Wego/ImplicitMemoizer
#
module ActiveRecord
  class Base
    include Memoizer

    class << self
      include Memoizer::ClassMethods
    end
  end
end

# Taken from https://github.com/girishso/pluck_to_hash
module PluckToHash
  extend ActiveSupport::Concern

  module ClassMethods
    def pluck_to_hash(*keys)
      formatted_keys = keys.map do |k|
        case k
        when String
          k.split(' as ')[-1].to_sym
        when Symbol
          k
        end
      end

      pluck(*keys).map do |row|
        row = [row] if keys.size == 1
        Hash[formatted_keys.zip(row)]
      end
    end

    alias_method :pluck_h, :pluck_to_hash
  end
end

ActiveRecord::Base.send(:include, PluckToHash)
