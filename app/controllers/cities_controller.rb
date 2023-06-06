class CitiesController < ApplicationController
  before_action :find_state_by_acronym, only: :import

  def index; end

  def show_imported
    @imported_cities = City.all
  end

  def import
    HTTParty::Basement.default_options.update(verify: false)

    state_sigla = params[:state_sigla].to_s.upcase

    response = HTTParty.get("https://servicodados.ibge.gov.br/api/v1/localidades/estados/#{state_sigla}/distritos")
    cities_data = response.code == 200 ? JSON.parse(response.body) : []

    return redirect_to root_path, alert: 'Invalid state!' if state_sigla.blank?
    return redirect_to root_path, alert: 'Error importing cities!' unless cities_data.present?

    if save_cities(cities_data)
      redirect_to show_imported_cities_path
    else
      redirect_to root_path, alert: 'Error importing cities!'
    end
  end

  def search
    name_param = params[:name].to_s.downcase
    state_param = params[:state].to_s.downcase

    city_query = City.where('lower(cities.name) LIKE ?', "%#{name_param}%")
    state_query = State.where('lower(states.name) LIKE ?', "%#{state_param}%")

    @matching_cities = city_query.joins(:state).merge(state_query)
  end

  private

  def find_state_by_acronym
    @state = State.find_by(acronym: params[:state_sigla].to_s.upcase)
    redirect_to root_path, alert: 'State not found' if @state.nil?
  end

  def save_cities(cities_data)
    random_cities = cities_data.sample(20)

    random_cities.each do |city_data|
      city = City.find_or_initialize_by(
        name: city_data['nome'],
        acronym: @state.acronym,
        country: @state.country,
        state: @state
      )
      city.save if city.valid?
    end
  end
end
