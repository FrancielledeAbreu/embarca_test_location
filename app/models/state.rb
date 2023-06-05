class State < ApplicationRecord
  enum country: { other_countries: 0, brasil: 1 }

  validates :name, presence: true
  validates :country, presence: true
end
