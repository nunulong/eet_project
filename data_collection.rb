require 'nokogiri'
require 'open-uri'

# Fetch and parse HTML document
doc = Nokogiri::HTML(open('http://bestgrouprealty.com/agents.aspx?id=59'))

# Search for nodes by css
sub_links = doc.css('table#GridAgents td a').map{|link| "http://bestgrouprealty.com/" + link.attr('href')}

# Iterate the links
rs = []
sub_links.each do |link|
  pp = {}
  sub_doc = Nokogiri::HTML(open(link))
  pp[:name] = sub_doc.css("span#lblTitle").text
  pp[:phone] = sub_doc.css("span#lblPhone").text
  pp[:email] = sub_doc.css("a#HyperLinkEmail").text.gsub(' {at} ', '@')
  rs << pp
end

# [{name: '', phone: '917', email: 'gmail.com'},{}]

# rs.each do 
#   word <<
# end

  ####
  # Search for nodes by xpath
