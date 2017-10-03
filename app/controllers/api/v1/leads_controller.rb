module Api::V1
  class LeadsController < ApplicationController
    require 'net/http'
    require 'uri'
    def search_source
      t = Lead.arel_table
      leads = (Lead.where(t[:source].matches("%#{params['source']}%")))
      if leads.empty?
        response = Lead::LeadHandler.search_by_source params['source']
        result = Lead::LeadHandler.parse_response response
        render json: result
      else
        render json: leads
      end
    end
  end
end
