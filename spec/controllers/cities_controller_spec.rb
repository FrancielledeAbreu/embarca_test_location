require 'rails_helper'

RSpec.describe CitiesController do
  describe 'GET index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show_imported' do
    let(:city) { create(:city) }

    it 'assigns imported cities' do
      get :show_imported
      expect(assigns(:imported_cities)).to contain_exactly(city)
    end

    it 'renders the show_imported template' do
      get :show_imported
      expect(response).to render_template(:show_imported)
    end
  end

  describe 'POST import' do
    let(:state) { create(:state) }

    it 'imports cities successfully' do
      allow(HTTParty).to receive(:get).and_return(
        double(code: 200, body: '[{"nome": "Curitiba"}]')
      )

      city_attributes = { name: 'Curitiba', acronym: state.acronym, country: state.country, state: state }
      expect do
        post :import, params: { state_sigla: 'PR' }
      end.to change { City.where(city_attributes).count }.by(1)

      expect(response).to redirect_to(show_imported_cities_path)
      expect(flash[:alert]).to be_nil
    end

    it 'redirects to root path with an alert for invalid state' do
      post :import, params: { state_sigla: '' }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('State not found')
    end

    it 'redirects to root path with an alert for error importing cities' do
      allow(HTTParty).to receive(:get).and_return(
        double(code: 500, body: 'Internal Server Error')
      )

      post :import, params: { state_sigla: 'PR' }

      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET search' do
    let(:state) { create(:state) }
    let(:state_two) { create(:state) }
    let(:city) { create(:city, name: 'Curitiba', state: state) }
    let(:city_two) { create(:city, name: 'Florianópolis', state: state_two) }

    it 'assigns matching cities by state' do
      get :search, params: { state: 'Paraná' }
      expect(assigns(:matching_cities)).to include(city)
      expect(assigns(:matching_cities)).not_to include(city_two)
    end

    it 'assigns matching cities by name' do
      get :search, params: { name: 'Curi' }
      expect(assigns(:matching_cities)).to include(city)
      expect(assigns(:matching_cities)).not_to include(city_two)
    end

    it 'assigns matching cities by state' do
      get :search, params: { state: 'Para' }
      expect(assigns(:matching_cities)).to include(city)
      expect(assigns(:matching_cities)).not_to include(city_two)
    end

    it 'assigns matching cities by name and state' do
      get :search, params: { name: 'Curitiba', state: 'Para' }
      expect(assigns(:matching_cities)).to include(city)
      expect(assigns(:matching_cities)).not_to include(city_two)
    end

    it 'does not assign matching cities when not found' do
      get :search, params: { name: 'Florianópolis', state: 'Paraná' }
      expect(assigns(:matching_cities)).to be_empty
    end

    it 'renders the search template' do
      get :search, params: { name: 'Curitiba', state: 'Paraná' }
      expect(response).to render_template(:search)
    end
  end
end
