require_relative 'spec_helper'

describe W3Clove::Warning do
  before(:each) do
    @warning = W3Clove::Warning.new('25', 100, 'general entity X not defined and no default entity')
  end

  it "should have a message_id" do
    @warning.message_id.should == '25'
  end

  it "should have a line" do
    @warning.line.should == 100
  end

  it "should have a message" do
    @warning.message.should == 'general entity X not defined and no default entity'
  end
end