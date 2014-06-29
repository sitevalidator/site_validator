# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe SiteValidator::Sitemap do
  before(:each) do
    @sitemap                              = SiteValidator::Sitemap.new('http://ryanair.com/sitemap.xml')
    @sitemap_dirty                        = SiteValidator::Sitemap.new('http://example.com/sitemap_dirty.xml')
    @sitemap_html_dirty                   = SiteValidator::Sitemap.new('http://example.com/dirty')
    @sitemap_html                         = SiteValidator::Sitemap.new('http://guides.rubyonrails.org')
    @sitemap_no_links                     = SiteValidator::Sitemap.new('http://zigotica.com')
    @sitemap_with_trailing_slash          = SiteValidator::Sitemap.new('http://eparreno.com')
    @sitemap_with_protocol_relative       = SiteValidator::Sitemap.new('http://protocol-relative.com')
    @sitemap_with_protocol_relative_https = SiteValidator::Sitemap.new('https://protocol-relative.com')
    @sitemap_for_exclusions               = SiteValidator::Sitemap.new('http://example.com/exclusions')
    @sitemap_for_exclusions_xml           = SiteValidator::Sitemap.new('http://example.com/exclusions.xml')
    @sitemap_for_absolute_urls            = SiteValidator::Sitemap.new('http://markupvalidator.com/faqs')
    @sitemap_international                = SiteValidator::Sitemap.new('http://example.com/international')
    @sitemap_with_safe_redirect           = SiteValidator::Sitemap.new('http://github.com')
    @sitemap_with_unsafe_redirect         = SiteValidator::Sitemap.new('https://unsafe.com')

    MarkupValidator.any_instance.stubs(:validate_uri).returns(stubbed_validator_results)
  end

  it "should have an URL" do
    @sitemap.url.should == 'http://ryanair.com/sitemap.xml'
  end

  describe "scraping pages" do
    it "should get its pages from a xml sitemap" do
      @sitemap.pages.length.should == 3
      @sitemap.pages[0].url.should == 'http://www.ryanair.com/es/'
      @sitemap.pages[1].url.should == 'http://www.ryanair.com/es/careers/job'
      @sitemap.pages[2].url.should == 'http://www.ryanair.com/es/about'
    end

    it "should not crash when encountering invalid locs on an xml sitemap" do
      expect {
        @sitemap_dirty.pages.length.should == 2
      }.to_not raise_error

      @sitemap_dirty.pages[0].url.should == 'http://www.ryanair.com/es/'
      @sitemap_dirty.pages[1].url.should == 'http://www.ryanair.com/es/careers/job'
    end

    it "should not crash when encountering invalid hrefs on an html page" do
      expect {
        @sitemap_html_dirty.pages.length.should == 4
      }.to_not raise_error

      @sitemap_html_dirty.pages[0].url.should == 'http://example.com/dirty'
      @sitemap_html_dirty.pages[1].url.should == 'http://example.com/'
      @sitemap_html_dirty.pages[2].url.should == 'http://example.com/faqs'
      @sitemap_html_dirty.pages[3].url.should == 'http://example.com/contact'
    end

    it "should get pages from the sample guides.rubyonrails.org site" do
      @sitemap_html.pages.map {|p| p.url}
        .should == ["http://guides.rubyonrails.org/",
                    "http://guides.rubyonrails.org/index.html",
                    "http://guides.rubyonrails.org/getting_started.html",
                    "http://guides.rubyonrails.org/migrations.html",
                    "http://guides.rubyonrails.org/active_record_validations_callbacks.html",
                    "http://guides.rubyonrails.org/association_basics.html",
                    "http://guides.rubyonrails.org/active_record_querying.html",
                    "http://guides.rubyonrails.org/layouts_and_rendering.html",
                    "http://guides.rubyonrails.org/form_helpers.html",
                    "http://guides.rubyonrails.org/action_controller_overview.html",
                    "http://guides.rubyonrails.org/routing.html",
                    "http://guides.rubyonrails.org/active_support_core_extensions.html",
                    "http://guides.rubyonrails.org/i18n.html",
                    "http://guides.rubyonrails.org/action_mailer_basics.html",
                    "http://guides.rubyonrails.org/testing.html",
                    "http://guides.rubyonrails.org/security.html",
                    "http://guides.rubyonrails.org/debugging_rails_applications.html",
                    "http://guides.rubyonrails.org/performance_testing.html",
                    "http://guides.rubyonrails.org/configuring.html",
                    "http://guides.rubyonrails.org/command_line.html",
                    "http://guides.rubyonrails.org/caching_with_rails.html",
                    "http://guides.rubyonrails.org/plugins.html",
                    "http://guides.rubyonrails.org/rails_on_rack.html",
                    "http://guides.rubyonrails.org/generators.html",
                    "http://guides.rubyonrails.org/contributing_to_ruby_on_rails.html",
                    "http://guides.rubyonrails.org/api_documentation_guidelines.html",
                    "http://guides.rubyonrails.org/ruby_on_rails_guides_guidelines.html",
                    "http://guides.rubyonrails.org/3_0_release_notes.html",
                    "http://guides.rubyonrails.org/2_3_release_notes.html",
                    "http://guides.rubyonrails.org/2_2_release_notes.html",
                    "http://guides.rubyonrails.org/contribute.html",
                    "http://guides.rubyonrails.org/credits.html",
                    "http://guides.rubyonrails.org/v2.3.8/"]
    end

    it "should follow safe (http => https) redirects" do
      expect {
        @sitemap_with_safe_redirect.pages
      }.to_not raise_error

      @sitemap_with_safe_redirect.pages.length.should == 36
    end

    it "should follow unsafe (https => http) redirects" do
      expect {
        @sitemap_with_unsafe_redirect.pages
      }.to_not raise_error

      @sitemap_with_unsafe_redirect.pages.length.should == 3
    end

    it "should get correct absolute links for internal pages" do
      @sitemap_for_absolute_urls.pages.length.should == 9
      @sitemap_for_absolute_urls.pages.map {|p| p.url}
        .should == ["http://markupvalidator.com/faqs",
                    "http://markupvalidator.com/",
                    "http://markupvalidator.com/plans-and-pricing",
                    "http://markupvalidator.com/contact",
                    "http://markupvalidator.com/charts/errors",
                    "http://markupvalidator.com/credits",
                    "http://markupvalidator.com/signin",
                    "http://markupvalidator.com/api_v1_reference",
                    "http://markupvalidator.com/terms_of_service"]
    end

    it "should include sitemap url at least, even if no links were found" do
      @sitemap_no_links.pages.length.should == 1
      @sitemap_no_links.pages[0].url.should == 'http://zigotica.com/'
    end

    it "should not repeat sitemap URL with and without trailing slash" do
      urls = @sitemap_with_trailing_slash.pages.collect(&:url)
      urls.should_not include 'http://eparreno.com'
      urls.should     include 'http://eparreno.com/'
    end

    it "should not repeat internal URLs with and without trailing slash" do
      urls = @sitemap_for_absolute_urls.pages.collect(&:url)
      urls.should      include 'http://markupvalidator.com/faqs'
      urls.should_not  include 'http://markupvalidator.com/faqs/'
    end

    it "should exclude non-html pages from HTML sitemaps" do
      @sitemap_for_exclusions.pages.length.should == 3
      @sitemap_for_exclusions.pages[0].url.should == 'http://example.com/exclusions'
      @sitemap_for_exclusions.pages[1].url.should == 'http://example.com/'
      @sitemap_for_exclusions.pages[2].url.should == 'http://example.com/faqs'
    end

    it "should exclude non-html pages from XML sitemaps" do
      @sitemap_for_exclusions_xml.pages.length.should == 2
      @sitemap_for_exclusions_xml.pages[0].url.should == 'http://example.com/'
      @sitemap_for_exclusions_xml.pages[1].url.should == 'http://example.com/faqs'
    end

    it "should not crash when URLs have international characters" do
      @sitemap_international.pages.length.should == 9
      @sitemap_international.pages[0].url.should == 'http://example.com/international'
      @sitemap_international.pages[1].url.should == 'http://example.com/roman%C3%A9e'
      @sitemap_international.pages[2].url.should == 'http://example.com/espa%C3%B1a'
      @sitemap_international.pages[3].url.should == 'http://example.com/roman%C3%A9e-2'
      @sitemap_international.pages[4].url.should == 'http://example.com/espa%C3%B1a-2'
      @sitemap_international.pages[5].url.should == 'http://example.com/search?q=espa%C3%B1a'
      @sitemap_international.pages[6].url.should == 'http://example.com/espa%C3%B1a-3'
      @sitemap_international.pages[7].url.should == 'http://example.com/search?q=cami%C3%B3n'
      @sitemap_international.pages[8].url.should == 'http://example.com/white%20space'
    end

    context "protocol-relative links" do
      it "should include only internal links" do
        @sitemap_with_protocol_relative.pages.size.should == 3
        @sitemap_with_protocol_relative.pages.map {|p| p.url}.sort.should == ['http://protocol-relative.com/',
                                                                              'http://protocol-relative.com/contact',
                                                                              'http://protocol-relative.com/faqs']
      end

      it "should include protocol-relative link to same domain" do
        @sitemap_with_protocol_relative.pages.map {|p| p.url}.should include 'http://protocol-relative.com/contact'
      end

      it "should have the same protocol than the root url" do
        @sitemap_with_protocol_relative_https.pages.map {|p| p.url}.should include 'https://protocol-relative.com/contact'
      end

      it "should not include protocol-relative link to another domain" do
        @sitemap_with_protocol_relative.pages.map {|p| p.url}.should_not include 'http://yahoo.com'
      end
    end

    it "should be able to limit the number of pages" do
      sitemap = SiteValidator::Sitemap.new('http://guides.rubyonrails.org', 10)
      sitemap.pages.length.should == 10
    end
  end

  describe "validations" do
    it "should know the errors of all of its pages as a whole" do
      @sitemap.errors.length.should == 9
      @sitemap.errors.each do |e|
        e.should be_an_instance_of SiteValidator::Message
        e.type.should == :error
      end
    end

    it "should know the warnings of all of its pages as a whole" do
      @sitemap.warnings.length.should == 9
      @sitemap.warnings.each do |w|
        w.should be_an_instance_of SiteValidator::Message
        w.type.should == :warning
      end
    end
  end
end# -*- encoding: utf-8 -*-
