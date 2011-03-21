# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe W3Clove::Page do
  before(:each) do
    @page = W3Clove::Page.new('http://www.ryanair.com/es/')
    MarkupValidator.any_instance.stubs(:validate_uri).returns(stubbed_validator_results)
  end

  it "should have an URL" do
    @page.url.should == "http://www.ryanair.com/es/"
  end

  it "should get its validation errors from the W3C" do
    @page.errors.length.should == 3

    @page.errors.each do |e|
      e.should be_an_instance_of W3Clove::Message
    end

    @page.errors[0].message_id.should == '25'
    @page.errors[0].line.should == '92'
    @page.errors[0].text.should == message_text('25')
    @page.errors[0].type.should == :error

    @page.errors[1].message_id.should == '325'
    @page.errors[1].line.should == '92'
    @page.errors[1].text.should == message_text('325')
    @page.errors[1].type.should == :error

    @page.errors[2].message_id.should == '325'
    @page.errors[2].line.should == '224'
    @page.errors[2].text.should == message_text('325')
    @page.errors[2].type.should == :error
  end

  it "should get its validation warnings from the W3C" do
    @page.warnings.length.should == 3

    @page.warnings.each do |w|
      w.should be_an_instance_of W3Clove::Message
    end

    @page.warnings[0].message_id.should == '338'
    @page.warnings[0].line.should == '92'
    @page.warnings[0].text.should == message_text('338')
    @page.warnings[0].type.should == :warning

    @page.warnings[1].message_id.should == '247'
    @page.warnings[1].line.should == '112'
    @page.warnings[1].text.should == message_text('247')
    @page.warnings[1].type.should == :warning

    @page.warnings[2].message_id.should == '247'
    @page.warnings[2].line.should == '202'
    @page.warnings[2].text.should == message_text('247')
    @page.warnings[2].type.should == :warning
  end
end

