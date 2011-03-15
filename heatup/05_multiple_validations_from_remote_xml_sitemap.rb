# Example of validation of a list of URLs from a remote XML sitemap

require 'open-uri'
require 'nokogiri'
require 'w3c_validators'
include W3CValidators
validator = MarkupValidator.new

totals = {:errors => 0, :warnings => 0}

doc = Nokogiri::XML(open('https://github.com/jaimeiniesta/w3clove/raw/master/spec/samples/sitemap.xml'))
doc.css('loc').collect {|item| item.text}.each do |url|
  puts "\nValidating markup of #{url}"
  results = validator.validate_uri(url)
  puts "#{results.errors.count} errors, #{results.warnings.count} warnings"
  totals[:errors] += results.errors.count
  totals[:warnings] += results.warnings.count
end

puts "\nTOTAL:#{totals[:errors]} errors, #{totals[:warnings]} warnings"





