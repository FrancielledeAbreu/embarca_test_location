require 'rails_helper'

RSpec.describe State, type: :model do
  describe 'validation' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:country) }
  end
  describe 'association' do
    it { should have_many(:cities) }
  end
end
