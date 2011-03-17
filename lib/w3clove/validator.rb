##
# Validator class is the one in charge of doing the validation loop
# for all pages on a sitemap and output the errors
#
module W3Clove
  module Validator
    attr_writer :printer

    extend self

    ##
    # Parses a remote xml sitemap and checks markup validation for each url within
    def check(url)
      sitemap = W3Clove::Sitemap.new(url)

      sitemap.pages.each do |page|
        printer.puts "\nValidating markup of #{page.url}"
        printer.puts "#{page.errors.length} errors, #{page.warnings.length} warnings"
      end

      printer.puts "\nTOTAL:#{sitemap.errors.length} errors, #{sitemap.warnings.length} warnings"
    end

    private

    def printer
      @printer ||= STDOUT
    end
  end
end