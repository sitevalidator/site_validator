# -*- encoding: utf-8 -*-

module W3Clove
  ##
  # Validator module is the one in charge of doing the validation loop
  # for all pages on a sitemap and output the errors
  #
  module Validator
    attr_writer :printer

    extend self

    ##
    # Parses a remote xml sitemap and checks markup validation for each url
    def check(url)
      sitemap = W3Clove::Sitemap.new(url)

      sitemap.pages.each do |page|
        printer.puts "\nValidating markup of #{page.url}"
        printer.puts page_summary(page)
      end

      printer.puts sitemap_summary(sitemap)
    end

    private

    def page_summary(page)
      "#{page.errors.length} errors, #{page.warnings.length} warnings"
    end

    def sitemap_summary(sitemap)
      <<HEREDOC
TOTAL: #{sitemap.errors.length} errors, #{sitemap.warnings.length} warnings
HEREDOC
    end

    def printer
      @printer ||= STDOUT
    end
  end
end