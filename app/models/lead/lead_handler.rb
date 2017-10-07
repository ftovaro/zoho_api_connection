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
      response = handler.search_in_zoho_by_source source, 1, records
      handler.parse_response response
    else
      leads
    end
  end
  def self.search_by_id_and_numbers id, phone, mobile, page, records
    handler = Lead::LeadHandler.new
    records = handler.default_records_value records
    page = handler.default_page_value page
    response = handler.search_in_zoho id, phone, mobile, page, records
    handler.parse_response response
  end
  def self.search_by_other_fields name, company, phone, page, records
    handler = Lead::LeadHandler.new
    t = Lead.arel_table
    records = handler.default_records_value records
    page = handler.default_page_value page
    leads = Lead.where(t[:name].matches("%#{name}%"), 
                       t[:company].matches("%#{company}%"), 
                       t[:phone].matches("%#{phone}%")).page(page).per(records)
    if leads.empty?
      response = handler.search_in_zoho_by_source source, 1, records
      handler.parse_response response
    else
      leads
    end
  end
  def search_in_zoho_by_source source, page, records
    handler = Lead::LeadHandler.new
    records = handler.default_records_value records
    page = handler.default_page_value page
    url = generate_url(handler.generate_params_source(source), page, records)
    handler.connect_to_zoho url
  end
  def search_in_zoho id, phone, mobile, page, records
    handler = Lead::LeadHandler.new
    records = handler.default_records_value records
    page = handler.default_page_value page
    if id
      url = generate_url_by_id id
    else
      url = generate_url(handler.generate_params_search(phone, mobile), page, records)
    end
    handler.connect_to_zoho url
  end
  def connect_to_zoho url
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
      leads_collection.push Lead.find_or_create_by(zoho_id: zoho_id, name: name, company: company, phone: phone, source: source, mobile: mobile)
    else
      leads.each do |lead|
        lead = lead['FL']
        zoho_id = lead.detect {|l| l['val'] == 'LEADID'}['content']
        name = lead.detect {|l| l['val'] == 'First Name'}['content']
        company = lead.detect {|l| l['val'] == 'Company'}['content']
        phone = lead.detect {|l| l['val'] == 'Phone'}['content']
        mobile = lead.detect {|l| l['val'] == 'Mobile'}['content']
        source = lead.detect {|l| l['val'] == 'Lead Source'}['content']
        leads_collection.push Lead.find_or_create_by(zoho_id: zoho_id, name: name, company: company, phone: phone, source: source, mobile: mobile)
      end
    end
    leads_collection
  end
  def generate_url search, page, records
    criteria = ""
    len = search.length
    search.each_with_index do |item, index|
      unless index == len - 1
        criteria += "(" + item[0] + item[1] + ")AND"
      else
        criteria += "(" + item[0] + item[1] + ")"
      end
    end
    "#{ENV['ZOHO_SEARCH_URL']}#{ENV['ZOHO_TOKEN']}&scope=crmapi&criteria=(#{criteria})&fromIndex=#{page}&toIndex=#{records}"
  end
  def generate_url_by_id id
    "#{ENV['ZOHO_SEARCH_BY_ID_URL']}#{ENV['ZOHO_TOKEN']}&scope=crmapi&id=#{id}"
  end
  def generate_params_search phone, mobile
    params = []
    params.push(['Phone:', phone]) if phone
    params.push(['Mobile:', mobile]) if mobile
    params
  end
  def generate_params_source source
    params = []
    params.push(['Lead Source:', source]) if source
    params
  end
  def default_page_value page
    page.blank? ? 1 : page
  end
  def default_records_value records
    records.blank? ? 25 : records
  end
end
