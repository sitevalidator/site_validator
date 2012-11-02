# -*- encoding: utf-8 -*-

require 'open-uri'
require 'nokogiri'
require 'metainspector'
require 'timeout'

module W3Clove
  ##
  # A sitemap has an URL, and holds a collection of pages to be validated
  #
  class Sitemap
    attr_accessor :url, :timeout

    def initialize(url, timeout = 20)
      @url      = url
      @timeout  = timeout
    end

    ##
    # Returns the first 250 unique URLs from the sitemap
    def pages
      @pages ||= pages_in_sitemap.uniq {|p| p.url}[0..249]
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
    # For HTML sources, it will only get the links that start with the sitemap root url, convert relative links
    # to absolute links, remove anchors from links, include the sitemap url, and exclude links that don't
    # seem to point to HTML (like images, multimedia, text, javascript...)
    def pages_in_sitemap
      pages = xml_locations.select {|loc| looks_like_html?(loc.text)}.map {|loc| W3Clove::Page.new(loc.text)}
      if pages.empty?
        m     = MetaInspector.new(url, timeout)
        links = [m.url]

        m.links.select {|l| l.start_with?(m.root_url) && looks_like_html?(l)}.map {|l| l.split('#')[0]}.uniq.each do |link|
          if link[-1,1] == "/"
            links << link unless (links.include?(link) || links.include?(link.chop))
          else
            links << link unless (links.include?(link) || links.include?("#{link}/"))
          end
        end

        pages = links.map {|link| W3Clove::Page.new(link)}
      end
      pages
    end

    # Tells if the given url looks like an HTML page.
    # That is, it does not look like javascript, image, pdf...
    def looks_like_html?(url)
      u         = URI.parse(URI.encode(url))
      scheme    = u.scheme                if u.scheme
      extension = u.path.split(".").last  if u.path

      (scheme && extension) && (scheme =~ /http[s]?/i) && (extension !~ /gif|jpg|jpeg|png|tiff|bmp|txt|pdf|doc|rtf|xml|xls|csv|wav|mp3|ogg/i)
    end

    def xml_locations
      Nokogiri::XML(doc).css('loc')
    end

    def doc
      @doc ||= open(url)
    end
  end
end