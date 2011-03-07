# Example of validation of a list of URLs

require 'w3c_validators'
include W3CValidators
validator = MarkupValidator.new

urls = %w{http://university.rubymendicant.com/
          http://university.rubymendicant.com/changelog.html
          http://university.rubymendicant.com/alumni.html}
totals = {:errors => 0, :warnings => 0}

urls.each do |url|
  puts "\nValidating markup of #{url}"
  results = validator.validate_uri(url)
  puts "#{results.errors.count} errors, #{results.warnings.count} warnings"
  totals[:errors] += results.errors.count
  totals[:warnings] += results.warnings.count
end

puts "\nTOTAL:#{totals[:errors]} errors, #{totals[:warnings]} warnings"





