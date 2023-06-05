require 'httparty'

HTTParty::Basement.default_options.update(verify: false)

response = HTTParty.get('https://servicodados.ibge.gov.br/api/v1/localidades/estados')
states_data = response.code == 200 ? JSON.parse(response.body) : []

southern_states_data = states_data.select { |state| state.dig('regiao', 'sigla') == 'S' }

success_count = southern_states_data.count do |state_data|
  state = State.find_or_initialize_by(name: state_data['nome'], acronym: state_data['sigla'])
  state.save
  state.valid?
end

status = response.code == 200 && success_count == southern_states_data.length ? 'success' : 'error'

puts "Data #{status == 'success' ? 'imported and saved' : 'error retrieving or saving'} successfully!"
