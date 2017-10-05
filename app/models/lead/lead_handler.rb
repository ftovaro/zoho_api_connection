class Lead::LeadHandler
  require 'net/http'
  require 'uri'
  def self.load_leads page, records
    handler = Lead::LeadHandler.new
    records = handler.default_records_value records
    page = handler.default_page_value page
    Lead.page(page).per(records)
  end
  def self.search_by_source source, page, records
    handler = Lead::LeadHandler.new
    t = Lead.arel_table
    records = handler.default_records_value records
    page = handler.default_page_value page
    leads = Lead.where(t[:source].matches("%#{source}%")).page(page).per(records)
    if leads.empty?
      response = handler.search_in_zoho source, 1, records
      handler.parse_response response
    else
      leads
    end
  end
  def search_in_zoho source, page, records
    url = "#{ENV['ZOHO_SEARCH_URL']}#{ENV['ZOHO_TOKEN']}&scope=crmapi&criteria=(Lead Source:#{source})&fromIndex=#{page}&toIndex=#{records}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")
    http.request(Net::HTTP::Get.new(uri.request_uri)).body
  end
  def parse_response response
    leads_collection = []
    leads = JSON.parse(response)['response']['result']['Leads']['row']
    if leads.is_a? Hash
      lead = leads['FL']
      zoho_id = lead.detect {|l| l['val'] == 'LEADID'}['content']
      name = lead.detect {|l| l['val'] == 'First Name'}['content']
      company = lead.detect {|l| l['val'] == 'Company'}['content']
      phone = lead.detect {|l| l['val'] == 'Phone'}['content']
      mobile = lead.detect {|l| l['val'] == 'Mobile'}['content']
      source = lead.detect {|l| l['val'] == 'Lead Source'}['content']
      leads_collection = Lead.find_or_create_by(zoho_id: zoho_id, name: name, company: company, phone: phone, source: source, mobile: mobile)
    else
      leads.each do |lead|
        lead = lead['FL']
        name = lead.detect {|l| l['val'] == 'First Name'}['content']
        company = lead.detect {|l| l['val'] == 'Company'}['content']
        phone = lead.detect {|l| l['val'] == 'Phone'}['content']
        mobile = lead.detect {|l| l['val'] == 'Mobile'}['content']
        source = lead.detect {|l| l['val'] == 'Lead Source'}['content']
        leads_collection = Lead.find_or_create_by(zoho_id: zoho_id, name: name, company: company, phone: phone, source: source, mobile: mobile)
      end
    end
    leads_collection
  end
  def default_page_value page
    page.blank? ? 1 : page
  end
  def default_records_value records
    records.blank? ? 25 : records
  end
end
