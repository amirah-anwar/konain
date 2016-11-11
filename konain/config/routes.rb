Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  resources :pages, only: :show

  resources :projects do
    collection do
      get "fetch_project"
    end
    member do
      get 'fetch_sub_projects'
    end
  end

  ActiveAdmin.routes(self)
  resources :properties

  devise_for :users, controllers: { registrations: "registrations", omniauth_callbacks: "omniauth_callbacks" }

  resources :users do
    member do
      get "assigned_properties"
      get "favourite_properties"
    end
  end

  resources :favourite_properties, only: [:create, :destroy]

  get '/agents', to: "users#agents"

  get '/lawyers', to: "users#lawyers"

  get '/architects', to: 'users#architects'

  post '/send_mail', to: 'emails#send_mail'

  get '/contact_us', to: 'emails#contact'

  post '/send_contact_mail', to: 'emails#send_contact_mail'

  get "/fetch_property_type", to: 'properties#fetch_property_type'

  get "/fetch_property_sub_type", to: 'properties#fetch_property_sub_type'

  get "/fetch_property_features", to: 'properties#fetch_property_features'

  get "/property_types", to: 'properties#property_types'

  get '/about_us', to: 'pages#about_us'

  get '/:permalink', to: "pages#show"

  get '/admin/fetch_types', to:"admin/properties#fetch_types"

  get '/admin/fetch_sub_types', to:"admin/properties#fetch_sub_types"

  get '/admin/fetch_features', to:"admin/properties#fetch_features"

  get '/admin/fetch_sub_projects/(:id)', to: 'admin/properties#fetch_sub_projects'

  root 'properties#home_page'

end
