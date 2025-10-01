Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace 'administracao', module: 'master_module' do
    devise_for :masters

    resources :companies do
      post :toggle_company_active
    end

    root 'master_module/companies#index'
  end

  scope ':company_id', as: :company, module: 'company_module' do
    devise_for :admins

    resources :dashboard, only: :index
    resources :events do
      post :event_toggle_visibility
    end

    resources :profile, only: %i[edit update]

    get ':event_name', to: 'event_pages#show', as: :event_page
    post ':event_name/buy_tickets', to: 'event_pages#buy_tickets', as: :buy_tickets
    get ':event_name/purchase_success', to: 'event_pages#purchase_success', as: :purchase_success

    root 'company_module/dashboard#index'
  end

end
