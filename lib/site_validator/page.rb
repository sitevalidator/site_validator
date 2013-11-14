# -*- encoding: utf-8 -*-

require 'timeout'
require 'w3c_validators'
include W3CValidators

module SiteValidator
  ##
  # A page has an URL to be validated, and a collection of errors
  # In case of an exception happens when validating, it is tracked
  #
  class Page
    attr_accessor :url, :timeout, :exception

    def initialize(url, timeout = 20)
      @url      = url
      @timeout  = timeout
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
      @errors ||= validations.errors
                    .select {|e| e.message_id && !e.message_id.empty?}
                    .map do |e|
        SiteValidator::Message.new(e.message_id, e.line, e.col, e.message, :error, e.source, prepare_w3c_explanation(e))
      end
    rescue Exception => e
      @exception = e.to_s
      nil
    end

    ##
    # Returns the collection of warnings from the validations of this page.
    # If it has no validation warnings, it will be an empty array.
    # It an exception occurs, it will be nil.
    def warnings
      @warnings ||= validations.warnings
                     .select {|w| w.message_id && !w.message_id.empty?}
                     .map do |w|
        SiteValidator::Message.new(w.message_id, w.line, w.col, w.message, :warning, w.source, prepare_w3c_explanation(w))
      end
    rescue Exception => e
      @exception = e.to_s
      nil
    end

    private

    ##
    # Gets the validations for this page, ensuring it times out soon
    def validations
      @validations ||= Timeout::timeout(timeout) { markup_validator.validate_uri(url) }
    end

    ##
    # Returns an instance of MarkupValidator, with the URL set to the one in ENV or its default
    def markup_validator
      @markup_validator ||= MarkupValidator.new(:validator_uri => ENV['W3C_MARKUP_VALIDATOR_URI'] || 'http://validator.w3.org/check',
                                                'user-agent'   => ENV['W3C_MARKUP_VALIDATOR_USER_AGENT'] || 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.76 Safari/537.36')
    end

    ##
    # Prepares the error message explanation, removing the feedback and adjusting the docs links
    def prepare_w3c_explanation(message)
      explanation = message.explanation

      if explanation
        explanation = remove_feedback_link(explanation)
        explanation.gsub!("docs/", "http://validator.w3.org/docs/")
        explanation.gsub!("our feedback channels", "the W3C feedback channels")
        explanation.strip!
        explanation = nil if explanation.size == 0
      end

      explanation
    end

    def remove_feedback_link(explanation)
      fragment = Nokogiri::HTML.fragment(explanation)
      fragment.at_css('p.helpwanted').remove
      fragment.to_html
    end
  end
end
