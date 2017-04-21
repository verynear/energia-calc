# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :structure_image do
    file_name 'foo'
    asset_content_type 'image/jpg'
  end
end
