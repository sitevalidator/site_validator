##
# A page has an URL to be validated, and a collection of errors
#
module W3Clove
  class Page
    require 'w3c_validators'
    include W3CValidators

    attr_accessor :url

    def initialize(url)
      @url = url
    end

    def errors
      @errors ||= MarkupValidator.new.validate_uri(url).errors.collect {|e| W3Clove::Error.new(e.message_id, e.line, e.message)}
    end

    def warnings
      @warnings ||= MarkupValidator.new.validate_uri(url).warnings.collect {|w| W3Clove::Warning.new(w.message_id, w.line, w.message)}
    end
  end
end