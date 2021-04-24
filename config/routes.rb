Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#index'
  scope ":locale", locale: /#{I18n.available_locales.join('|')}/ do
    root 'application#index', as: :root_with_locale
  end

  routes = -> do
    namespace :expressions do
      get '/', to: 'expressions#index'

      get "/tasks/:token", to: 'expressions#show_task'
      get :check_expression, to: 'expressions#check_expression', format: :json
      post :create_task, to: 'expressions#create_task', format: :json
    end
  end

  routes.call
  scope ":locale", locale: /#{I18n.available_locales.join('|')}/ do
    routes.call
  end


  routes = -> do
    namespace :algorithms do
      get '/', to: 'algorithms#index'
      get '/beta', to: 'algorithms#index', defaults: {beta: false}

      get "/tasks/:token", to: 'algorithms#show_task'
      get "/beta/tasks/:token", to: 'algorithms#show_task', defaults: {beta: true}
      get :check_expression, to: 'algorithms#check_expression', format: :json
      post :create_task, to: 'algorithms#create_task', format: :json
      post :verify_trace_act, to: 'algorithms#verify_trace_act', format: :json
      get :available_syntaxes, to: 'algorithms#available_syntaxes', format: :json
    end
  end

  routes.call
  scope ":locale", locale: /#{I18n.available_locales.join('|')}/ do
    routes.call
  end
end
