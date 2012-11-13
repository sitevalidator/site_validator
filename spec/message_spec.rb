# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe SiteValidator::Message do
  before(:each) do
    @error_message   = SiteValidator::Message.new('25',
                                            100,
                                            message_text('25'),
                                            :error)
    @warning_message = SiteValidator::Message.new('25',
                                            100,
                                            message_text('25'),
                                            :warning)
  end

  it "should have a message_id" do
    @error_message.message_id.should == '25'
  end

  it "should have a line" do
    @error_message.line.should == 100
  end

  it "should have a text" do
    @error_message.text.should == message_text('25')
  end

  it "should have a type" do
    @error_message.type == :error
    @warning_message.type == :warning
  end
end