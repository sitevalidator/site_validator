# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe W3Clove::Sitemap do
  before(:each) do
    @sitemap = W3Clove::Sitemap.new('http://ryanair.com/sitemap.xml')
    @sitemap.stub!(:doc).and_return(open("#{$samples_dir}/sitemap.xml"))
    MarkupValidator.any_instance.stubs(:validate_uri).returns(stubbed_validator_results)
  end

  it "should have an URL" do
    @sitemap.url.should == 'http://ryanair.com/sitemap.xml'
  end

  it "should get its pages from the xml, removing repeated urls" do
    @sitemap.pages.length.should == 3
    @sitemap.pages[0].url.should == 'http://www.ryanair.com/es/'
    @sitemap.pages[1].url.should == 'http://www.ryanair.com/es/careers/job'
    @sitemap.pages[2].url.should == 'http://www.ryanair.com/es/about'
  end

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