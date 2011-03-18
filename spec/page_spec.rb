# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe W3Clove::Page do
  before(:each) do
    @page = W3Clove::Page.new('http://www.ryanair.com/es/')
  end

  it "should have an URL" do
    @page.url.should == "http://www.ryanair.com/es/"
  end

  it "should get its validation errors from the W3C" do
    @page.errors.length.should == 4

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

    @page.errors[3].message_id.should == '65'
    @page.errors[3].line.should == '235'
    @page.errors[3].text.should == message_text('65')
    @page.errors[3].type.should == :error
  end

  it "should get its validation warnings from the W3C" do
    @page.warnings.length.should == 9

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

    @page.warnings[3].message_id.should == '247'
    @page.warnings[3].line.should == '202'
    @page.warnings[3].text.should == message_text('247')
    @page.warnings[3].type.should == :warning

    @page.warnings[4].message_id.should == '247'
    @page.warnings[4].line.should == '203'
    @page.warnings[4].text.should == message_text('247')
    @page.warnings[4].type.should == :warning

    @page.warnings[5].message_id.should == '247'
    @page.warnings[5].line.should == '204'
    @page.warnings[5].text.should == message_text('247')
    @page.warnings[5].type.should == :warning

    @page.warnings[6].message_id.should == '247'
    @page.warnings[6].line.should == '214'
    @page.warnings[6].text.should == message_text('247')
    @page.warnings[6].type.should == :warning

    @page.warnings[7].message_id.should == '247'
    @page.warnings[7].line.should == '214'
    @page.warnings[7].text.should == message_text('247')
    @page.warnings[7].type.should == :warning

    @page.warnings[8].message_id.should == '247'
    @page.warnings[8].line.should == '255'
    @page.warnings[8].text.should == message_text('247')
    @page.warnings[8].type.should == :warning
  end
end