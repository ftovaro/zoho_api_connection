require 'net/http'
require 'uri'

url = "https://crm.zoho.com/crm/private/json/Leads/getRecords?authtoken=416af38494ac9b2499db14633128ba35&scope=crmapi"
uri = URI.parse(url)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = (uri.scheme == "https")
response = http.request(Net::HTTP::Get.new(uri.request_uri)).body
leads = JSON.parse(response)['response']['result']['Leads']['row']
leads.each do |lead|
  lead = lead['FL']
  zoho_id = lead.detect {|l| l['val'] == 'LEADID'}['content']
  name = lead.detect {|l| l['val'] == 'First Name'}['content']
  company = lead.detect {|l| l['val'] == 'Company'}['content']
  phone = lead.detect {|l| l['val'] == 'Phone'}['content']
  mobile = lead.detect {|l| l['val'] == 'Mobile'}['content']
  source = lead.detect {|l| l['val'] == 'Lead Source'}['content']
  new_lead = Lead.find_or_create_by(zoho_id: zoho_id, name: name, company: company, phone: phone, source: source, mobile: mobile)
  p "New lead created with name: #{name} and company #{company}"
end
