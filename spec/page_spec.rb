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
      e.should be_an_instance_of W3Clove::Error
    end

    @page.errors[0].message_id.should == '25'
    @page.errors[0].line.should == '92'
    @page.errors[0].message.should == 'general entity "B" not defined and no default entity'

    @page.errors[1].message_id.should == '325'
    @page.errors[1].line.should == '92'
    @page.errors[1].message.should == 'reference to entity "B" for which no system identifier could be generated'

    @page.errors[2].message_id.should == '325'
    @page.errors[2].line.should == '224'
    @page.errors[2].message.should == 'reference to entity "B" for which no system identifier could be generated'

    @page.errors[3].message_id.should == '65'
    @page.errors[3].line.should == '235'
    @page.errors[3].message.should == 'document type does not allow element "P" here; missing one of "APPLET", "OBJECT", "MAP", "IFRAME", "BUTTON" start-tag'
  end

  it "should get its validation warnings from the W3C" do
    @page.warnings.length.should == 9

    @page.warnings.each do |w|
      w.should be_an_instance_of W3Clove::Warning
    end

    @page.warnings[0].message_id.should == '338'
    @page.warnings[0].line.should == '92'
    @page.warnings[0].message.should == 'cannot generate system identifier for general entity "B"'

    @page.warnings[1].message_id.should == '247'
    @page.warnings[1].line.should == '112'
    @page.warnings[1].message.should == 'NET-enabling start-tag requires SHORTTAG YES'

    @page.warnings[2].message_id.should == '247'
    @page.warnings[2].line.should == '202'
    @page.warnings[2].message.should == 'NET-enabling start-tag requires SHORTTAG YES'

    @page.warnings[3].message_id.should == '247'
    @page.warnings[3].line.should == '202'
    @page.warnings[3].message.should == 'NET-enabling start-tag requires SHORTTAG YES'

    @page.warnings[4].message_id.should == '247'
    @page.warnings[4].line.should == '203'
    @page.warnings[4].message.should == 'NET-enabling start-tag requires SHORTTAG YES'

    @page.warnings[5].message_id.should == '247'
    @page.warnings[5].line.should == '204'
    @page.warnings[5].message.should == 'NET-enabling start-tag requires SHORTTAG YES'

    @page.warnings[6].message_id.should == '247'
    @page.warnings[6].line.should == '214'
    @page.warnings[6].message.should == 'NET-enabling start-tag requires SHORTTAG YES'

    @page.warnings[7].message_id.should == '247'
    @page.warnings[7].line.should == '214'
    @page.warnings[7].message.should == 'NET-enabling start-tag requires SHORTTAG YES'

    @page.warnings[8].message_id.should == '247'
    @page.warnings[8].line.should == '255'
    @page.warnings[8].message.should == 'NET-enabling start-tag requires SHORTTAG YES'
  end
end