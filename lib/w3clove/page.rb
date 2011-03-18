# -*- encoding: utf-8 -*-

require 'w3c_validators'
include W3CValidators

module W3Clove
  ##
  # A page has an URL to be validated, and a collection of errors
  #
  class Page
    attr_accessor :url

    def initialize(url)
      @url = url
    end

    def errors
      @errors ||= validations.errors.map {|e|
                                          W3Clove::Message.new(e.message_id,
                                                               e.line,
                                                               e.message,
                                                               :error)}
    end

    def warnings
      @warnings ||= validations.warnings.map {|w|
                                              W3Clove::Message.new(w.message_id,
                                                                   w.line,
                                                                   w.message,
                                                                   :warning)}
    end

    private

    def validations
      @validations ||= MarkupValidator.new.validate_uri(url)
    end
  end
end