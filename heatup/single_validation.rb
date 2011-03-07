# Example of validation of a single URL

require 'w3c_validators'
include W3CValidators
validator = MarkupValidator.new

url = 'http://university.rubymendicant.com/'
puts "Validating markup of #{url}"

results = validator.validate_uri(url)

if results.errors.length > 0
  puts "There are #{results.errors.length} validation errors"
else
  puts 'Valid!'
end