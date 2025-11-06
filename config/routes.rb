Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace 'webhooks', module: 'webhooks_module' do
    post 'asaas/checkout_status', to: 'asaas_hooks#checkout_status'
  end

  namespace 'administracao', module: 'master_module' do
    devise_for :masters

    resources :companies do
      post :toggle_company_active
    end

    root to: 'master_module/companies#index'
  end

  scope ':company_id', as: :company, module: 'company_module' do
    devise_for :admins

    resources :dashboard, only: :index
    resources :events do
      post :event_toggle_visibility
      post 'cancel_payment/:ticket_id/:payment_id', to: 'events#cancel_payment', as: :cancel_payment
    end

    resources :profile, only: %i[edit update]

    get '/', to: 'event_pages#index', as: :all_events
    get ':event_name', to: 'event_pages#show', as: :event_page
    post ':event_name/buy_tickets', to: 'event_pages#buy_tickets', as: :buy_tickets
    get ':event_name/subs_success/:token_pay', to: 'event_pages#subs_success', as: :subs_success
    get ':event_name/subs_cancel/:token_pay', to: 'event_pages#subs_cancel', as: :subs_cancel
    get ':event_name/subs_expired/:token_pay', to: 'event_pages#subs_expired', as: :subs_expired
    get ':event_name/subs_confirm/:token_pay', to: 'event_pages#subs_confirm', as: :subs_confirm
    get ':event_name/event_not_found', to: 'event_pages#event_not_found', as: :event_not_found

    root to: 'event_pages#index'
  end

end
