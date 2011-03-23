# -*- encoding: utf-8 -*-

require 'timeout'
require 'w3c_validators'
include W3CValidators

module W3Clove
  ##
  # A page has an URL to be validated, and a collection of errors
  # In case of an exception happens when validating, it is tracked
  #
  class Page
    attr_accessor :url, :exception

    def initialize(url)
      @url = url
    end

    ##
    # Checks for errors and returns true if none found, false otherwise.
    # Warnings are not considered as validation errors so a page with
    # warnings but without errors will return true.
    # If the validation goes well, errors should be an array. Otherwise
    # it will still be nil, which will not be considered validated.
    def valid?
      !errors.nil? && errors.empty?
    end

    ##
    # Returns the collection of errors from the validations of this page.
    # If it has no validation errors, it will be an empty array.
    # It an exception occurs, it will be nil.
    def errors
      @errors ||= validations.errors.map {|e|
                                          W3Clove::Message.new(e.message_id,
                                                               e.line,
                                                               e.message,
                                                               :error)}
    rescue Exception => e
      @exception = e.to_s
      nil
    end

    ##
    # Returns the collection of warnings from the validations of this page.
    # If it has no validation warnings, it will be an empty array.
    # It an exception occurs, it will be nil.
    def warnings
      @warnings ||= validations.warnings.map {|w|
                                              W3Clove::Message.new(w.message_id,
                                                                   w.line,
                                                                   w.message,
                                                                   :warning)}
    rescue Exception => e
      @exception = e.to_s
      nil
    end

    private

    ##
    # Gets the validations for this page, ensuring it times out soon
    def validations
      @validations ||= Timeout::timeout(10) { MarkupValidator.new.validate_uri(url) }
    end
  end
end