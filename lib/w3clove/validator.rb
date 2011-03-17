##
# Validator class is the one in charge of doing the validation loop
# for all pages on a sitemap and output the errors
#
module W3Clove
  module Validator
    extend self

    ##
    # Parses a remote xml sitemap and checks markup validation for each url within
    def check(url)
      sitemap = W3Clove::Sitemap.new(url)

      sitemap.pages.each do |page|
        puts "\nValidating markup of #{page.url}"
        puts "#{page.errors.length} errors, #{page.warnings.length} warnings"
      end

      puts "\nTOTAL:#{sitemap.errors.length} errors, #{sitemap.warnings.length} warnings"
    end
  end
end