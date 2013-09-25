# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe SiteValidator::Message do
  before(:each) do
    @error_message   = SiteValidator::Message.new('25',
                                                  100,
                                                  20,
                                                  message_text('25'),
                                                  :error,
                                                  'a code snippet',
                                                  'an explanation')
    @warning_message = SiteValidator::Message.new('25',
                                                  100,
                                                  20,
                                                  message_text('25'),
                                                  :warning,
                                                  'a code snippet',
                                                  'an explanation')
  end

  it "should have a message_id" do
    @error_message.message_id.should == '25'
  end

  it "should have a line" do
    @error_message.line.should == 100
  end

  it "should have a col" do
    @error_message.col.should == 20
  end

  it "should have a text" do
    @error_message.text.should == message_text('25')
  end

  it "should have a type" do
    @error_message.type.should    == :error
    @warning_message.type.should  == :warning
  end

  it "should have a source" do
    @error_message.source.should    == 'a code snippet'
    @warning_message.source.should  == 'a code snippet'
  end

  it "should have an explanation" do
    @error_message.explanation.should    == 'an explanation'
    @warning_message.explanation.should  == 'an explanation'
  end
end
