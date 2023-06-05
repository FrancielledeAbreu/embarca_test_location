class State < ApplicationRecord
  has_many :cities

  enum country: { other_countries: 0, brasil: 1 }

  validates :name, presence: true
  validates :country, presence: true
end
