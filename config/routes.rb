Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  devise_for :admins

  scope ':company', as: :company, module: 'company_module' do
    resources :home, only: :index
    resources :events do
      post :event_toggle_visibility
    end

    # scope ':event_name', as: :event do
    #   resources :event_pages, only: :index
    # end
    get ':event_name', to: 'event_pages#show', as: :event_page
  end

  root to: 'company_module/home#index'
end
