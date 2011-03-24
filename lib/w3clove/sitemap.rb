# -*- encoding: utf-8 -*-

require 'open-uri'
require 'nokogiri'

module W3Clove
  ##
  # A sitemap has an URL, and holds a collection of pages to be validated
  #
  class Sitemap
    attr_accessor :url

    def initialize(url)
      @url = url
    end

    ##
    # Returns the first 100 unique URLs from the sitemap
    def pages
      @pages ||= pages_in_sitemap.uniq {|p| p.url}[0..99]
    end

    ##
    # Returns the combined validation errors of all the pages
    def errors
      @errors ||= pages.map {|p| p.errors}.flatten.reject {|e| e.nil?}
    end

    ##
    # Returns the combined validation warnings of all the pages
    def warnings
      @warnings ||= pages.map {|p| p.warnings}.flatten.reject {|e| e.nil?}
    end

    ##
    # Returns the binding, needed to paint the ERB template when generating
    # the HTML report (see w3clove/reporter.rb)
    def get_binding
      binding
    end

    private

    def pages_in_sitemap
      locations.map {|loc| W3Clove::Page.new(loc.text)}
    end

    def locations
      Nokogiri::XML(doc).css('loc')
    end

    def doc
      @doc ||= open(url)
    end
  end
end