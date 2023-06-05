class CitiesController < ApplicationController
  before_action :find_state_by_acronym, only: :import

  def index

  end

  def import
    HTTParty::Basement.default_options.update(verify: false)

    state_sigla = params[:state_sigla].upcase

    response = HTTParty.get("https://servicodados.ibge.gov.br/api/v1/localidades/estados/#{state_sigla}/distritos")
    cities_data = response.code == 200 ? JSON.parse(response.body) : []

    save_cities(cities_data)

    redirect_to root_path, notice: 'Cities imported and saved successfully!'
  end

  private

  def find_state_by_acronym
    @state = State.find_by(acronym: params[:state_sigla].upcase)
    redirect_to root_path, alert: 'State not found' if @state.nil?
  end

  def save_cities(cities_data)
    cities_data.take(20).each do |city_data|
      city = City.new(name: city_data['nome'], acronym: @state.acronym, country: @state.country, state: @state)
      city.save if city.valid?
    end
  end
end
