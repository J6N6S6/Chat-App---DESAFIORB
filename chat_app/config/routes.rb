Rails.application.routes.draw do
  # Verificação de saúde da aplicação (opcional)
  get "up" => "rails/health#show", as: :rails_health_check

  get "/users/find", to: "users#find_by_email"

  # Rotas para mensagens
  resources :messages, only: [ :create, :index, :show ]
  resources :sessions, only: [ :create ]
  resources :users, only: [ :show, :create ] # Adiciona a rota GET /users/:id e POST /users

  # Rotas para arquivos
  get "/files/:id", to: "files#show", as: :file

  # Rotas de autenticação (login e signup)
  post "/login", to: "sessions#create"

  # Cadastro de usuário
  post "/signup", to: "users#create"

  # Defina a rota raiz (opcional)
  # root "messages#index"
end
