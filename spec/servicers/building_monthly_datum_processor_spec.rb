require 'rails_helper'

describe BuildingMonthlyDatumProcessor do
  describe '#execute' do
    it 'does not save yearly value if less than 12 data points' do
      data = Array.new(11, date: 'date', value: 1.0)
      bmd = create(:building_monthly_datum, data: data)

      processor = described_class.new(datum: bmd)
      processor.execute
      expect(bmd.yearly_data).to eq(nil)
    end

    it 'sums most recent 12 months when all data is consecutive' do
      data = [
        { date: '2014-04-01', value: 2.0 },
        { date: '2014-05-01', value: 2.0 },
        { date: '2014-06-01', value: 2.0 },
        # start of months that will be used
        { date: '2014-07-01', value: 4.0 },
        { date: '2014-08-01', value: 4.0 },
        { date: '2014-09-01', value: 4.0 },
        { date: '2014-10-01', value: 4.0 },
        { date: '2014-11-01', value: 4.0 },
        { date: '2014-12-01', value: 4.0 },
        { date: '2015-01-01', value: 4.0 },
        { date: '2015-02-01', value: 4.0 },
        { date: '2015-03-01', value: 4.0 },
        { date: '2015-04-01', value: 4.0 },
        { date: '2015-05-01', value: 4.0 },
        { date: '2015-06-01', value: 4.0 },
        # gap in months
        { date: '2015-08-01', value: 6.0 }
      ]
      bmd = create(:building_monthly_datum, data: data)

      processor = described_class.new(datum: bmd)
      processor.execute
      expect(bmd.yearly_data).to eq(48.0)
    end

    it 'does not save yearly value if not enough consecutive data' do
      data = [
        # 12 months total, but with a gap
        { date: '2014-08-01', value: 4.0 },
        { date: '2014-09-01', value: 4.0 },
        { date: '2014-10-01', value: 4.0 },
        { date: '2014-11-01', value: 4.0 },
        { date: '2014-12-01', value: 4.0 },
        { date: '2015-01-01', value: 4.0 },
        { date: '2015-02-01', value: 4.0 },
        { date: '2015-03-01', value: 4.0 },
        { date: '2015-04-01', value: 4.0 },
        { date: '2015-05-01', value: 4.0 },
        { date: '2015-06-01', value: 4.0 },
        { date: '2015-08-01', value: 6.0 }
      ]
      bmd = create(:building_monthly_datum, data: data)

      processor = described_class.new(datum: bmd)
      processor.execute
      expect(bmd.yearly_data).to eq(nil)
    end
  end
end
