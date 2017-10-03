class Lead::LeadHandler
  def self.search_by_source source
    url = "#{ENV['ZOHO_SEARCH_URL']}#{ENV['ZOHO_TOKEN']}&scope=crmapi&criteria=(Lead Source:#{source})"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")
    http.request(Net::HTTP::Get.new(uri.request_uri)).body
  end
  def self.parse_response response
    leads_collection = []
    leads = JSON.parse(response)['response']['result']['Leads']['row']
    if leads.is_a? Hash
      lead = leads['FL']
      name = lead.detect {|l| l['val'] == 'First Name'}['content']
      company = lead.detect {|l| l['val'] == 'Company'}['content']
      phone = lead.detect {|l| l['val'] == 'Phone'}['content']
      mobile = lead.detect {|l| l['val'] == 'Mobile'}['content']
      source = lead.detect {|l| l['val'] == 'Lead Source'}['content']
      leads_collection = Lead.find_or_create_by(name: name, company: company, phone: phone, source: source, mobile: mobile)
    else
      leads.each do |lead|
        lead = lead['FL']
        name = lead.detect {|l| l['val'] == 'First Name'}['content']
        company = lead.detect {|l| l['val'] == 'Company'}['content']
        phone = lead.detect {|l| l['val'] == 'Phone'}['content']
        mobile = lead.detect {|l| l['val'] == 'Mobile'}['content']
        source = lead.detect {|l| l['val'] == 'Lead Source'}['content']
        leads_collection = Lead.find_or_create_by(name: name, company: company, phone: phone, source: source, mobile: mobile)
      end
    end
    leads_collection
  end
end
