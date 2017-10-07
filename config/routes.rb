Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/leads/seach_source', to: 'leads#search_source'
      get '/leads/search_lead', to: 'leads#search_lead'
      get '/leads/search_others', to: 'leads#search_other_fields_leads'
      get '/leads', to: 'leads#index'
    end
  end
end
