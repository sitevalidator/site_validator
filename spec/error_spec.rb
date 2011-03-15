require_relative 'spec_helper'

describe W3Clove::Error do
  before(:each) do
    @error = W3Clove::Error.new('25', 100, 'general entity X not defined and no default entity')
  end

  it "should have a message_id" do
    @error.message_id.should == '25'
  end

  it "should have a line" do
    @error.line.should == 100
  end

  it "should have a message" do
    @error.message.should == 'general entity X not defined and no default entity'
  end
end