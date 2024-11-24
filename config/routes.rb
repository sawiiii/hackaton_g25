Rails.application.routes.draw do
  resources :projects do
    resources :positions
  end
  resources :messages


  # post "people/projects/new", to: "projects#create"
  resources :positions do
    resources :applications, only: [ :create ]
  end

  resources :people, param: :auth0_id do
    resources :projects do
      resources :positions do
        resources :applications, only: [ :index, :show ]
      end
    end
  end

  resources :people do
    get "/applications", to: "applications#user_applications"
    get "/applications/:id", to: "applications#user_application"
    put "/applications/:id/change_status", to: "applications#change_status"
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
