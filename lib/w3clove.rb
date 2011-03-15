module W3clove
  require 'open-uri'
  require 'nokogiri'
  require 'w3c_validators'
  include W3CValidators

  extend self

  ##
  # Parses a remote xml sitemap and checks markup validation for each url within
  def check_sitemap(sitemap_url)
    validator = MarkupValidator.new

    totals = {:errors => 0, :warnings => 0}

    doc = Nokogiri::XML(open(sitemap_url))
    doc.css('loc').collect {|item| item.text}.each do |url|
      puts "\nValidating markup of #{url}"
      results = validator.validate_uri(url)
      puts "#{results.errors.count} errors, #{results.warnings.count} warnings"
      totals[:errors] += results.errors.count
      totals[:warnings] += results.warnings.count
    end

    puts "\nTOTAL:#{totals[:errors]} errors, #{totals[:warnings]} warnings"
  end
end
