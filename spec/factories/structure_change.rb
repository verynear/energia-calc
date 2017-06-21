FactoryGirl.define do
  factory :structure_change do
    measure_selection { create(:measure_selection) }
    structure_type
  end
end
