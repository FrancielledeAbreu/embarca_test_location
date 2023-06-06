FactoryBot.define do
  factory :city do
    sequence(:name) { |n| "City #{n}" }
    country { 'brasil' }
    acronym { 'PR' }
    association :state
  end
end
