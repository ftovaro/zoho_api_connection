module Api::V1
  class LeadsController < ApplicationController
    def index
      leads = Lead::LeadHandler.load_leads params['page'], params['records']
      render json: leads
    end
    def search_source
      leads = Lead::LeadHandler.search_by_source params['source'], params['page'], params['records']
      render json: leads
    end
    def search_other_fields_leads
      leads = Lead::LeadHandler.search_by_other_fields params['name'], params['company'], params['phone'], params['page'], params['records']
      render json: leads
    end
    def search_lead
      leads = Lead::LeadHandler.search_by_id_and_numbers params['id'], params['phone'], params['mobile'], params['page'], params['records']
      render json: leads
    end
  end
end
