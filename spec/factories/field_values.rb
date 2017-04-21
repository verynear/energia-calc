# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :field_value do
    field nil
    structure nil
    string_value "MyString"
    float_value 1.5
    decimal_value "9.99"
    integer_value 1
    date_value "2014-10-01 18:58:56"
    boolean_value false
    successful_upload_on "2014-10-01 18:58:56"
    upload_attempt_on "2014-10-01 18:58:56"
  end
end
