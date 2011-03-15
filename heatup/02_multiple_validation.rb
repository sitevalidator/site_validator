# Example of validation of a list of URLs

require 'w3c_validators'
include W3CValidators
validator = MarkupValidator.new

urls = %w{http://www.ryanair.com/es/
          http://www.ryanair.com/es/careers/job
          http://www.ryanair.com/es/about}
totals = {:errors => 0, :warnings => 0}

urls.each do |url|
  puts "\nValidating markup of #{url}"
  results = validator.validate_uri(url)
  puts "#{results.errors.count} errors, #{results.warnings.count} warnings"
  totals[:errors] += results.errors.count
  totals[:warnings] += results.warnings.count
end

puts "\nTOTAL:#{totals[:errors]} errors, #{totals[:warnings]} warnings"





