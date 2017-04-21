shared_examples 'measure' do |measure_name|
  include CalculationSupport

  let!(:measure) { Kilomeasure.get_measure(measure_name) }
  let!(:shared_inputs) { {} }

  before do |example|
    Kilomeasure.load

    @example = example
  end

  it 'is a valid measure file' do
    validate_measure(measure_name)
  end
end
