##
# A sitemap has an URL, and holds a collection of pages to be validated
#
module W3Clove
  require 'open-uri'
  require 'nokogiri'

  class Sitemap
    attr_accessor :url

    def initialize(url)
      @url = url
    end

    def pages
      @pages ||= Nokogiri::XML(doc).css('loc').collect {|loc| W3Clove::Page.new(loc.text)}.uniq {|p| p.url}
    end

    def errors
      pages.collect {|p| p.errors}.flatten
    end

    def warnings
      pages.collect {|p| p.warnings}.flatten
    end

    private

    def doc
      @doc ||= open(url)
    end
  end
end