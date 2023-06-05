Rails.application.routes.draw do
  root to: 'cities#index'
  post 'cities/import', to: 'cities#import', as: 'import_cities'
  get 'cities/show_imported', to: 'cities#show_imported', as: 'show_imported_cities'
end
