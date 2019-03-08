Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :organisations
      resources :organisation_types
      resources :policy_areas
      resources :regions
    end
  end
end
