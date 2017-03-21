# rubocop:disable Wego/ImplicitMemoizer
#
class WegoBase
  include Memoizer

  class << self
    include Memoizer
  end
end
