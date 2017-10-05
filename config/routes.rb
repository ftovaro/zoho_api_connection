Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/leads/seach_source', to: 'leads#search_source'
      get '/leads/search_lead', to: 'leads#search_lead'
      get '/leads', to: 'leads#index'
    end
  end
end
