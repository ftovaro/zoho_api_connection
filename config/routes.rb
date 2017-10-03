Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/leads/seach_source', to: 'leads#search_source'
    end
  end
end
