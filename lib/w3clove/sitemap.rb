# -*- encoding: utf-8 -*-

require 'open-uri'
require 'nokogiri'
require 'metainspector'

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

    # Scrapes the url in search of links.
    #
    # It first assumes it's an XML sitemap; if no locations found, it will try to
    # scrape the links from HTML.
    #
    # For HTML sources, it will only get the links that start with the sitemap url, convert relative links
    # to absolute links, remove anchors from links, and include the sitemap url
    def pages_in_sitemap
      pages = xml_locations.map {|loc| W3Clove::Page.new(loc.text)}
      if pages.empty?
        m     = MetaInspector.new(url)
        links = ([m.url] + m.absolute_links.select {|l| l.start_with?(m.url)}.map {|l| l.split('#')[0]}).uniq
        pages = links.map {|link| W3Clove::Page.new(link)}
      end
      pages
    end

    def xml_locations
      Nokogiri::XML(doc).css('loc')
    end

    def doc
      @doc ||= open(url)
    end
  end
end