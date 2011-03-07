# Example of validation of a list of URLs

require 'w3c_validators'
include W3CValidators
validator = MarkupValidator.new

urls = %w{http://university.rubymendicant.com/
          http://university.rubymendicant.com/changelog.html
          http://university.rubymendicant.com/alumni.html}

urls.each do |url|
  puts "\nValidating markup of #{url}"
  results = validator.validate_uri(url)

  if results.errors.length > 0
    puts "There are #{results.errors.length} validation errors"
  else
    puts 'Valid!'
  end
end





