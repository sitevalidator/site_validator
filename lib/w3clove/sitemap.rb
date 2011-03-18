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

    def pages
      @pages ||= pages_in_sitemap.uniq {|p| p.url}
    end

    def errors
      pages.map {|p| p.errors}.flatten
    end

    def warnings
      pages.map {|p| p.warnings}.flatten
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