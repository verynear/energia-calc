require 'rails_helper'

describe WegowiseClient do
  describe '#initialize' do
    it 'succeeds if user is provided' do
      user = create(:user)
      expect { described_class.new(user: user) }.to_not raise_error
    end

    it 'fails if user is not provided' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end
  end
end
