require 'nokogiri'
require 'open-uri'
require 'csv'
start_time = Time.now
# Fetch and parse HTML document
doc = Nokogiri::HTML(open('http://www.winzonerealty.com/StaffProfiles'))

# Search for nodes by css
links = doc.css('td > div > a').map{|link| "http://www.winzonerealty.com/" + link.attr('href')}

# Iterate the links
result = []
links.each do |link|
  people = {}
  sub_doc = Nokogiri::HTML(open(link))
  tr_list = sub_doc.css('form#Form1 table table').first.css('tr')
  people[:name] = tr_list[2].text.gsub("\t", "").gsub("\r", "").gsub("\n", "").chop
  people[:phone] = tr_list[3].css('td').text.gsub("\t", '').gsub("\r", '').gsub("\n", '').gsub("Phone: ", "")
  people[:email] = tr_list[5].text.gsub("\t", "").gsub("\r", "").gsub("\n", "").gsub("E-mail: ", "")
  current_time = Time.now
  puts (current_time - start_time)
  puts people.inspect
  result << people
end

# [{name: '', phone: '917', email: 'gmail.com'},{}]
CSV.open("./file_1.csv", "wb") do |csv|
  csv << %w(name phone email)
  result.each do |people|
    csv << [people[:name], people[:phone], people[:email]]
  end
end