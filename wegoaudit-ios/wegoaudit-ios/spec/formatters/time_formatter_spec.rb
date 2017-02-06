describe 'TimeFormatter' do
  describe '.from_string' do
    it 'returns the correct date' do
      date = TimeFormatter.from_string('2014-11-15T21:06:43.793Z')
      date.year.should == 2014
      date.month.should == 11
      date.day.should == 15
    end

    it 'returns nil if the date is not properly formatted' do
      date = TimeFormatter.from_string('Not a date')
      date.should == nil
    end
  end
end
