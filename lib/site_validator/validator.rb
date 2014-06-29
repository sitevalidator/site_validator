# -*- encoding: utf-8 -*-

module SiteValidator
  ##
  # Validator module is the one in charge of doing the validation loop
  # for all pages on a sitemap and output the errors
  #
  module Validator
    attr_writer :printer

    extend self

    ##
    # Parses a remote xml sitemap and checks markup validation for each url
    # Shows progress on dot-style (...F...FFE..). A dot is a valid page,
    # an F is a page with errors, and an E is an exception
    # After the checking is done, a detailed summary is written to filename
    def check(url, filename, max_pages)
      sitemap = SiteValidator::Sitemap.new(url, max_pages.to_i)
      say "Validating #{sitemap.pages.length} pages"

      sitemap.pages.each do |page|
        say_inline page.valid? ? "." : (page.errors.nil? ? 'E' : 'F')
      end

      SiteValidator::Reporter.generate_html(sitemap, filename)
      say "\nValidation finished, see the report at #{filename}"
    end

    private

    def printer
      @printer ||= STDOUT
    end

    ##
    # A shorter alias for printer.puts
    def say(text)
      printer.puts text
    end

    ##
    # A shorter alias for printer.print
    def say_inline(text)
      printer.print text
    end
  end
end
