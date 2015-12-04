require 'nokogiri'
require 'open-uri'
require 'csv'

ids = %w(373709 371671 372687 372840 373321 373024)

rs = []

ids.each do |id|
  # Fetch and parse HTML document
  doc = Nokogiri::HTML(open('http://www.mlsli.com/Office/OfficeInfo.aspx?OfficeID=' + id))
  # Search for nodes by css

  doc.css('.ao-details-agent').each do |agent|
    pp = {}
    pp[:name] = agent.css('.ao-details-agent-name').text
    pp[:email] = agent.css('.ao-details-agent-cta a').attr('href').text.slice(/address\=.*\&agent/).gsub('address=', '').gsub('&agent', '')
    puts pp.inspect
    rs << pp
  end
end
# Iterate the links

# Put data into csv file
CSV.open("./file_2.csv", "wb") do |csv|
  rs.each do |pp|
    csv << [pp[:name], pp[:email]]
  end
end