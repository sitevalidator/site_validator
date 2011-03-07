# Example of validation of a list of URLs from a text file

require 'w3c_validators'
include W3CValidators
validator = MarkupValidator.new

totals = {:errors => 0, :warnings => 0}
File.open("urls.txt", "r") do |file|
  file.each_line do |url|
    puts "\nValidating markup of #{url}"
    results = validator.validate_uri(url)
    puts "#{results.errors.count} errors, #{results.warnings.count} warnings"
    totals[:errors] += results.errors.count
    totals[:warnings] += results.warnings.count
  end
end

puts "\nTOTAL:#{totals[:errors]} errors, #{totals[:warnings]} warnings"





