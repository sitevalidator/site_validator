# -*- encoding: utf-8 -*-

require 'nokogiri'
require 'metainspector'

module SiteValidator
  ##
  # A sitemap has an URL, and holds a collection of pages to be validated
  #
  class Sitemap
    attr_accessor :url, :max_pages

    def initialize(url, max_pages = 100)
      @url       = url
      @max_pages = max_pages
    end

    ##
    # Returns the first 250 unique URLs from the sitemap
    def pages
      @pages ||= pages_in_sitemap.uniq {|p| p.url}[0..max_pages-1]
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
    # the HTML report (see site_validator/reporter.rb)
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
      pages = xml_locations.select {|loc| looks_like_html?(loc.text.strip)}.map {|loc| SiteValidator::Page.new(loc.text.strip)}

      if pages.empty?
        m     = scraped_doc
        links = [m.url]

        m.links.internal.select {|l| looks_like_html?(l)}.map {|l| l.split('#')[0]}.uniq.each do |link|
          if link[-1,1] == "/"
            links << link unless (links.include?(link) || links.include?(link.chop))
          else
            links << link unless (links.include?(link) || links.include?("#{link}/"))
          end
        end

        pages = links.map {|link| SiteValidator::Page.new(link)}
      end
      pages
    end

    # Tells if the given url looks like an HTML page.
    # That is, it does not look like javascript, image, pdf...
    def looks_like_html?(url)
      u         = URI.parse(URI.encode(url))
      scheme    = u.scheme                if u.scheme
      extension = u.path.split(".").last  if u.path

      (scheme =~ /http[s]?/i) && (extension !~ /gif|jpg|jpeg|png|tiff|bmp|txt|pdf|mobi|epub|doc|rtf|xml|xls|csv|wav|mp3|ogg|zip|rar|tar|gz/i)
    rescue URI::InvalidURIError
      false
    end

    def xml_locations
      Nokogiri::XML(doc).css('loc')
    end

    def scraped_doc
      @scraped_doc ||= MetaInspector.new(url, headers: {'User-Agent'      => SiteValidator::USER_AGENT,
                                                        'Accept-Encoding' => 'none' },
                                              faraday_options: { ssl: { verify: false } })
    end

    def doc
      @doc ||= scraped_doc.to_s
    end
  end
end
