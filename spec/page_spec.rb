# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe SiteValidator::Page do
  before(:each) do
    @page = SiteValidator::Page.new('http://www.ryanair.com/es/')
    MarkupValidator.any_instance
      .stubs(:validate_uri)
      .with('http://www.ryanair.com/es/')
      .returns(stubbed_validator_results)
  end

  it "should have an URL" do
    @page.url.should == "http://www.ryanair.com/es/"
  end

  it "should be valid when it has no errors" do
    @page.errors.should_not be_empty
    @page.should_not be_valid
  end

  it "should be valid when it has no errors, even if it has warnings" do
    page = SiteValidator::Page.new('http://example.com/no_errors_but_warnings')
    MarkupValidator.any_instance
      .stubs(:validate_uri)
      .with('http://example.com/no_errors_but_warnings')
      .returns(stubbed_validator_results(false))
    page.errors.should be_empty
    page.warnings.should_not be_empty
    page.should be_valid
  end

  it "should not be valid if an exception happened when validating" do
    page = SiteValidator::Page.new('http://example.com/timeout')
    MarkupValidator.any_instance
      .stubs(:validate_uri)
      .with('http://example.com/timeout')
      .raises(TimeoutError)
    page.errors.should be_nil
    page.should_not be_valid
  end

  it "should get its validation errors from the W3C" do
    @page.errors.length.should == 3

    @page.errors.each do |e|
      e.should be_an_instance_of SiteValidator::Message
    end

    @page.errors[0].message_id.should == '25'
    @page.errors[0].line.should == '92'
    @page.errors[0].col.should == '22'
    @page.errors[0].text.should == message_text('25')
    @page.errors[0].type.should == :error
    @page.errors[0].source.should == 'a code snippet for line 92'
    @page.errors[0].explanation.should == 'an explanation for error 25'

    @page.errors[1].message_id.should == '325'
    @page.errors[1].line.should == '92'
    @page.errors[1].col.should == '22'
    @page.errors[1].text.should == message_text('325')
    @page.errors[1].type.should == :error
    @page.errors[1].source.should == 'another code snippet for line 92'
    @page.errors[1].explanation.should == 'an explanation for error 325'

    @page.errors[2].message_id.should == '325'
    @page.errors[2].line.should == '224'
    @page.errors[2].col.should == '17'
    @page.errors[2].text.should == message_text('325')
    @page.errors[2].type.should == :error
    @page.errors[2].source.should == 'another code snippet for line 325'
    @page.errors[2].explanation.should == 'an explanation for error 325'
  end

  it "should get its validation warnings from the W3C" do
    @page.warnings.length.should == 3

    @page.warnings.each do |w|
      w.should be_an_instance_of SiteValidator::Message
    end

    @page.warnings[0].message_id.should == '338'
    @page.warnings[0].line.should == '92'
    @page.warnings[0].col.should == '22'
    @page.warnings[0].text.should == message_text('338')
    @page.warnings[0].type.should == :warning
    @page.warnings[0].source.should == 'a code snippet for line 338'
    @page.warnings[0].explanation.should == 'an explanation for warning 338'

    @page.warnings[1].message_id.should == '247'
    @page.warnings[1].line.should == '112'
    @page.warnings[1].col.should == '18'
    @page.warnings[1].text.should == message_text('247')
    @page.warnings[1].type.should == :warning
    @page.warnings[1].source.should == 'another code snippet for line 247'
    @page.warnings[1].explanation.should == 'an explanation for warning 247'

    @page.warnings[2].message_id.should == '247'
    @page.warnings[2].line.should == '202'
    @page.warnings[2].col.should == '47'
    @page.warnings[2].text.should == message_text('247')
    @page.warnings[2].type.should == :warning
    @page.warnings[2].source.should == 'another code snippet for line 247'
    @page.warnings[2].explanation.should == 'an explanation for warning 247'
  end

  it "should recover from timeouts when checking for errors" do
    page = SiteValidator::Page.new('http://example.com/timeout')
    MarkupValidator.any_instance
      .stubs(:validate_uri)
      .with('http://example.com/timeout')
      .raises(TimeoutError)
    lambda { page.errors }.should_not raise_error
    page.errors.should be_nil
    page.exception.should == 'Timeout::Error'
  end

  it "should recover from timeouts when checking for warnings" do
    page = SiteValidator::Page.new('http://example.com/timeout')
    MarkupValidator.any_instance
      .stubs(:validate_uri)
      .with('http://example.com/timeout')
      .raises(TimeoutError)
    lambda { page.warnings }.should_not raise_error
    page.warnings.should be_nil
    page.exception.should == 'Timeout::Error'
  end

  it "should not record empty errors returned by the validator" do
    mocked_validator = SiteValidator::MockedValidator.new
    mocked_validator.add_error('25', '92', '22', message_text('25'), 'code snippet', 'an explanation')
    mocked_validator.add_error('', '', '', '', '', '')
    mocked_validator.add_error(nil, nil, nil, nil, nil, nil)
    MarkupValidator.any_instance
      .stubs(:validate_uri)
      .with('http://example.com/emptyerrors')
      .returns(mocked_validator)
    page = SiteValidator::Page.new('http://example.com/emptyerrors')
    page.errors.length.should == 1
    page.errors.first.message_id.should == '25'
  end

  it "should not record empty warnings returned by the validator" do
    mocked_validator = SiteValidator::MockedValidator.new
    mocked_validator.add_warning('25', '92', '22', message_text('25'), 'code snippet', 'an explanation')
    mocked_validator.add_warning('', '', '', '', '', '')
    mocked_validator.add_warning(nil, nil, nil, nil, nil, nil)
    MarkupValidator.any_instance
      .stubs(:validate_uri)
      .with('http://example.com/emptyerrors')
      .returns(mocked_validator)
    page = SiteValidator::Page.new('http://example.com/emptyerrors')
    page.warnings.length.should == 1
    page.warnings.first.message_id.should == '25'
  end
end

