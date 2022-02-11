Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#index'
  get :publications, to: 'application#publications'
  resource :teacher_feedback, only: :create
  resources :attempts, only: :create do
    member do
      get :statistic
    end
  end
  put '/users/claim_task', to: 'users#claim_task', format: :json

  scope ":locale", locale: /#{I18n.available_locales.join('|')}/ do
    devise_for :users
    root 'application#index', as: :root_with_locale
    get :publications, to: 'application#publications'
    resource :teacher_feedback, only: :create
    resources :attempts, only: :create do
      member do
        get :statistic
      end
    end
    put '/users/claim_task', to: 'users#claim_task', format: :json
  end

  get '/diagram-demo', to: redirect('/en/algorithms/beta/tasks/bd51df206deb86779699461bb4122822')

  routes = -> do
    namespace :expressions do
      get '/', to: 'expressions#index'

      get :tasks, to: 'expressions#tasks'
      get "/tasks/:token", to: 'expressions#show_task'
      get "/tasks/:token/statistic", to: 'expressions#task_statistic'
      get :check_expression, to: 'expressions#check_expression', format: :json
      get :learn_more, to: 'expressions#learn_more', format: :json
      get :learn_more_next, to: 'expressions#learn_more_next', format: :json
      post :create_task, to: 'expressions#create_task', format: :json
      get :available_syntaxes, to: 'expressions#available_syntaxes', format: :json
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

      get :tasks, to: 'algorithms#tasks'
      get "/tasks/preview", to: 'algorithms#preview_task'
      get "/beta/tasks/preview", to: 'algorithms#preview_task', defaults: {beta: true}
      get "/tasks/:token", to: 'algorithms#show_task'
      get "/tasks/:token/statistic", to: 'algorithms#task_statistic'
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
