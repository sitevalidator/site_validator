# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe W3Clove::Sitemap do
  before(:each) do
    @sitemap = W3Clove::Sitemap.new('http://ryanair.com/sitemap.xml')
    @sitemap.stub!(:doc).and_return(open("#{$samples_dir}/sitemap.xml"))

    @sitemap_html = W3Clove::Sitemap.new('http://guides.rubyonrails.org')
    @sitemap_html.stub!(:doc).and_return(open("#{$samples_dir}/guides.rubyonrails.org.html"))

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

    it "should get pages from the sample guides.rubyonrails.org site" do
      @sitemap_html.pages.length.should == 34
      @sitemap_html.pages.map {|p| p.url}.should == ["http://guides.rubyonrails.org/index.html", "http://guides.rubyonrails.org/", "http://guides.rubyonrails.org/getting_started.html", "http://guides.rubyonrails.org/migrations.html", "http://guides.rubyonrails.org/active_record_validations_callbacks.html", "http://guides.rubyonrails.org/association_basics.html", "http://guides.rubyonrails.org/active_record_querying.html", "http://guides.rubyonrails.org/layouts_and_rendering.html", "http://guides.rubyonrails.org/form_helpers.html", "http://guides.rubyonrails.org/action_controller_overview.html", "http://guides.rubyonrails.org/routing.html", "http://guides.rubyonrails.org/active_support_core_extensions.html", "http://guides.rubyonrails.org/i18n.html", "http://guides.rubyonrails.org/action_mailer_basics.html", "http://guides.rubyonrails.org/testing.html", "http://guides.rubyonrails.org/security.html", "http://guides.rubyonrails.org/debugging_rails_applications.html", "http://guides.rubyonrails.org/performance_testing.html", "http://guides.rubyonrails.org/configuring.html", "http://guides.rubyonrails.org/command_line.html", "http://guides.rubyonrails.org/caching_with_rails.html", "http://guides.rubyonrails.org/asset_pipeline.html", "http://guides.rubyonrails.org/plugins.html", "http://guides.rubyonrails.org/rails_on_rack.html", "http://guides.rubyonrails.org/generators.html", "http://guides.rubyonrails.org/contributing_to_ruby_on_rails.html", "http://guides.rubyonrails.org/api_documentation_guidelines.html", "http://guides.rubyonrails.org/ruby_on_rails_guides_guidelines.html", "http://guides.rubyonrails.org/3_1_release_notes.html", "http://guides.rubyonrails.org/3_0_release_notes.html", "http://guides.rubyonrails.org/2_3_release_notes.html", "http://guides.rubyonrails.org/2_2_release_notes.html", "http://guides.rubyonrails.org/credits.html", "http://guides.rubyonrails.org/v2.3.11/"]
    end
  end

  describe "validations" do
    it "should know the errors of all of its pages as a whole" do
      @sitemap.errors.length.should == 9
      @sitemap.errors.each do |e|
        e.should be_an_instance_of W3Clove::Message
        e.type.should == :error
      end
    end

    it "should know the warnings of all of its pages as a whole" do
      @sitemap.warnings.length.should == 9
      @sitemap.warnings.each do |w|
        w.should be_an_instance_of W3Clove::Message
        w.type.should == :warning
      end
    end
  end
end