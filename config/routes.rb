Rails.application.routes.draw do
  root to: 'cities#index'
  post 'cities/import', to: 'cities#import', as: 'import_cities'
end
