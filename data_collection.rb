require 'nokogiri'
require 'open-uri'
require 'csv'

# Fetch and parse HTML document
doc = Nokogiri::HTML(open('http://bestgrouprealty.com/agents.aspx?id=59'))

# Search for nodes by css
sub_links = doc.css('table#GridAgents td a').map{|link| "http://bestgrouprealty.com/" + link.attr('href')}

# Iterate the links
rs = []
sub_links[0..20].each do |link|
  pp = {}
  sub_doc = Nokogiri::HTML(open(link))
  pp[:name] = sub_doc.css("span#lblTitle").text
  pp[:phone] = sub_doc.css("span#lblPhone").text
  pp[:email] = sub_doc.css("a#HyperLinkEmail").text.gsub(' {at} ', '@')
  puts pp.inspect
  rs << pp
end

# [{name: '', phone: '917', email: 'gmail.com'},{}]
CSV.open("./file.csv", "wb") do |csv|
  csv << %w(name phone email)
  rs.each do |pp|
    csv << [pp[:name], pp[:phone], pp[:email]]
  end
end
  ####
  # Search for nodes by xpath
