require_relative 'spec_helper'

describe W3Clove::Message do
  before(:each) do
    @error_message   = W3Clove::Message.new('25', 100, 'general entity X not defined and no default entity', :error)
    @warning_message = W3Clove::Message.new('25', 100, 'general entity X not defined and no default entity', :warning)
  end

  it "should have a message_id" do
    @error_message.message_id.should == '25'
  end

  it "should have a line" do
    @error_message.line.should == 100
  end

  it "should have a text" do
    @error_message.text.should == 'general entity X not defined and no default entity'
  end

  it "should have a type" do
    @error_message.type == :error
    @warning_message.type == :warning
  end
end